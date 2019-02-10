#!/bin/bash

# Keeping initial variables for future reference
INITIAL_ORACLE_SID=$ORACLE_SID
INITIAL_PATH=$PATH
INITIAL_ORACLE_HOME=$ORACLE_HOME
INITIAL_LD_LIBRARY_PATH=$LD_LIBRARY_PATH



DBNAME=$1
SID=$ORACLE_SID
LD_LIBRARY_PATH=$LD_LIBRARY_PATH
PATH=$PATH
ORACLE_HOME=$ORACLE_HOME
HOSTNAME=`hostname|cut -f1 -d"."`
SILENT=true

GRID_HOME=

function set_grid_env() {

	ORAENV_ASK=NO
	ORACLE_SID=+ASM1

	#. oraenv >> /dev/null
	oasm >> /dev/null

	GRID_HOME=$ORACLE_HOME

}


function get_oracle_home() {

RESSOURCE=`echo $1|awk '{print tolower($0)}'`
 
echo `crsctl status resource $RESSOURCE -f|grep ORACLE_HOME=|sed s'/ORACLE_HOME=//'`
 
}
 
function get_instances() {
 
#echo `crsctl status resource ora.soasc.db -f|grep GEN_USR_ORA_INST_NAME@SERVERNAME|sed s'/GEN_USR_ORA_INST_NAME@SERVERNAME(//'|sed s'/)//'`
RESSOURCE=`echo $1|awk '{print tolower($0)}'`

echo `crsctl status resource $RESSOURCE -f|grep GEN_USR_ORA_INST_NAME@SERVERNAME|sed s'/GEN_USR_ORA_INST_NAME@SERVERNAME(//'|sed s'/)//'`
 
}
 
function get_local_instance() {
 
#echo `crsctl status resource ora.soasc.db -f|grep GEN_USR_ORA_INST_NAME@SERVERNAME|sed s'/GEN_USR_ORA_INST_NAME@SERVERNAME(//'|sed s'/)//'| grep $HOSTNAME|awk -F'=' '{print $NF}'`
RESOURCE=`echo $1|awk '{print tolower($0)}'`

echo `crsctl status resource $RESOURCE -f|grep GEN_USR_ORA_INST_NAME@SERVERNAME|sed s'/GEN_USR_ORA_INST_NAME@SERVERNAME(//'|sed s'/)//'| grep $HOSTNAME|awk -F'=' '{print $NF}'`
}


function list_all_databases() {

  # List all database resources in cluster
  DBRESOURCES=$`crsctl status resource -w "(TYPE == ora.database.type)"|grep NAME=|sed s'/NAME=//'`
  #crsctl status resource -w "(TYPE == ora.database.type)" -p|grep ENABLED@SERVERNAME| sed 's/ENABLED@SERVERNAME(/Instance on /'| sed 's/)=1/ is enabled./'| sed 's/)=0/ is disabled./'
 
  # List all running instances with node info
  while read -r res; do
 
  DB_UNIQUE_NAME=`echo $res|sed s'/ora.//'|sed s'/.db//'`
  ORACLE_HOME=$(get_oracle_home $res)
  INSTANCES=$(get_instances $res)
  INSTANCE=$(get_local_instance $res)
  HOSTS_W_RUNNING_INSTANCES=$(get_hosts_w_running_instances $res)
 
  #echo "Database $DB_UNIQUE_NAME is running from ORACLE_HOME `crsctl status resource $res -f|grep ORACLE_HOME=|sed s'/ORACLE_HOME=//'`"
  echo "Database $DB_UNIQUE_NAME is running from ORACLE_HOME $ORACLE_HOME"
  echo "Database $res has the following instances:"
  #echo $INSTANCES
  if [ -n "$INSTANCE" ]; then  
    # Do something when var is non-zero length
            echo "Instance $INSTANCE is running on this host ($HOSTNAME)."
           
  else
   
            echo "Database has no running instances on this host ($HOSTNAME)."
            echo "Database has running instances on the following hosts:"
#            echo $HOSTS_W_RUNNING_INSTANCES
 
  fi
 
  done <<< $DBRESOURCES

}



function set_ora_env() {

	ORACLE_SID=$1
	ORACLE_HOME=$2
	DB_UNIQUE_NAME=$3


	# Strip GRID_HOME from all relevant variables
	LD_LIBRARY_PATH=`echo $LD_LIBRARY_PATH | sed "s;$GRID_HOME/lib;;g"| sed "s/::/:/g"`
	ORACLE_HOME=`echo $ORACLE_HOME | sed "s;$GRID_HOME/lib;;g"`
	#ORACLE_HOME=`echo $ORACLE_HOME | sed "s;$GRID_HOME/lib;;g"`
	PATH=`echo $INITIAL_PATH | sed "s;$GRID_HOME/lib;;g"`


	if [[ $INITIAL_ORACLE_HOME = $ORACLE_HOME ]]; then
	
		# ORACLE_HOME is identical to the previous ORACLE_HOME
		echo "ORACLE_HOME remains unchanged."
	else
	
		# ORACLE_HOME differs from the previous ORACLE_HOME
		echo "ORACLE_HOME is changed to $ORACLE_HOME."
	fi


#
# Reset LD_LIBRARY_PATH
#
case ${LD_LIBRARY_PATH:-""} in
    *$INITIAL_ORACLE_HOME/lib*)     	LD_LIBRARY_PATH=`echo $LD_LIBRARY_PATH | sed "s;$INITIAL_ORACLE_HOME/lib;$ORACLE_HOME/lib;g"` ;;
    *$ORACLE_HOME/lib*) ;;
    "")                 		LD_LIBRARY_PATH=$ORACLE_HOME/lib ;;
    *)                  		LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH ;;
esac

export LD_LIBRARY_PATH




#
# Put new ORACLE_HOME in path and remove old one
#

case "$INITIAL_ORACLE_HOME" in
    "") INITIAL_ORACLE_HOME=$PATH ;;        #This makes it so that null OLDHOME can't match
esac                            #anything in next case statement

case "$PATH" in
    *$INITIAL_ORACLE_HOME/bin*)     	PATH=`echo $PATH | sed "s;$INITIAL_ORACLE_HOME/bin;$ORACLE_HOME/bin;g"` ;;
    *$ORACLE_HOME/bin*) ;;
    *:)                 		PATH=${PATH}$ORACLE_HOME/bin: ;;
    "")                 		PATH=$ORACLE_HOME/bin ;;
    *)                  		PATH=$PATH:$ORACLE_HOME/bin ;;
esac

PATH=`echo $PATH | sed "s;$GRID_HOME/bin;;g"`

export PATH 



# Locate "osh" and exec it if found
ULIMIT=`LANG=C ulimit 2>/dev/null`

if [ $? = 0 -a "$ULIMIT" != "unlimited" ] ; then
  if [ "$ULIMIT" -lt 2113674 ] ; then

    if [ -f $ORACLE_HOME/bin/osh ] ; then
        exec $ORACLE_HOME/bin/osh
    else
        for D in `echo $PATH | tr : " "`
        do
            if [ -f $D/osh ] ; then
                exec $D/osh
            fi
        done
    fi

  fi

fi


# ORACLE_BASE

ORABASE_EXEC=$ORACLE_HOME/bin/orabase

if [ ${ORACLE_BASE:-"x"} != "x" ]; then
   OLD_ORACLE_BASE=$ORACLE_BASE
   unset ORACLE_BASE
   export ORACLE_BASE     
else
   OLD_ORACLE_BASE=""
fi

if [ -w $ORACLE_HOME/inventory/ContentsXML/oraclehomeproperties.xml ]; then
   if [ -f $ORABASE_EXEC ]; then
      if [ -x $ORABASE_EXEC ]; then
         ORACLE_BASE=`$ORABASE_EXEC`

         # did we have a previous value for ORACLE_BASE
         if [ ${OLD_ORACLE_BASE:-"x"} != "x" ]; then
            if [ $OLD_ORACLE_BASE != $ORACLE_BASE ]; then
               if [ "$SILENT" != "true" ]; then
                  echo "The Oracle base has been changed from $OLD_ORACLE_BASE to $ORACLE_BASE"
               fi
            else
               if [ "$SILENT" != "true" ]; then
                  echo "The Oracle base remains unchanged with value $OLD_ORACLE_BASE"
               fi
            fi
         else
            if [ "$SILENT" != "true" ]; then
               echo "The Oracle base has been set to $ORACLE_BASE"
            fi
         fi
         export ORACLE_BASE
      else
         if [ "$SILENT" != "true" ]; then
            echo "The $ORACLE_HOME/bin/orabase binary does not have execute privilege"
            echo "for the current user, $USER.  Rerun the script after changing"
            echo "the permission of the mentioned executable."
            echo "You can set ORACLE_BASE manually if it is required."
         fi
      fi
   else
      if [ "$SILENT" != "true" ]; then
         echo "The $ORACLE_HOME/bin/orabase binary does not exist"
         echo "You can set ORACLE_BASE manually if it is required."
      fi
   fi
else
   if [ "$SILENT" != "true" ]; then
      echo "ORACLE_BASE environment variable is not being set since this"
      echo "information is not available for the current user ID $USER."
      echo "You can set ORACLE_BASE manually if it is required."
   fi
fi

if [ ${ORACLE_BASE:-"x"} == "x" ]; then
     if [ "$SILENT" != "true" ]; then
         echo "Resetting ORACLE_BASE to its previous value or ORACLE_HOME";
     fi
     if [ "$OLD_ORACLE_BASE" != "" ]; then
          ORACLE_BASE=$OLD_ORACLE_BASE ;
          if [ "$SILENT" != "true" ]; then
                 echo "The Oracle base remains unchanged with value $OLD_ORACLE_BASE";
         fi
    else
          ORACLE_BASE=$ORACLE_HOME ;
          if [ "$SILENT" != "true" ]; then
                 echo "The Oracle base has been set to $ORACLE_HOME";
         fi
    fi
    export ORACLE_BASE ;
fi

	echo ""
        echo -e "\e[1mYour Oracle database environment is set to:\e[0m"
        echo "=============================================================="
        echo "ORACLE_SID      : $ORACLE_SID"
        echo "PATH            : $PATH"
        echo "ORACLE_HOME     : $ORACLE_HOME"
        echo "LD_LIBRARY_PATH : $LD_LIBRARY_PATH"
	echo ""

        echo -e "\e[1mLocal instance status:\e[0m"
        echo "=============================================================="
	srvctl status instance -d $DB_UNIQUE_NAME -i $ORACLE_SID -v -f
	echo ""
        echo -e "\e[1mDatabase status:\e[0m"
        echo "=============================================================="
	srvctl status database -d $DB_UNIQUE_NAME -v -f

}


function list_resources() {

        echo ""
        echo -e "\e[1mThe following Oracle Database Resources exist in this cluster:\e[0m"
	echo "=============================================================="
	echo ""
        
	# List all database resources in cluster
	#RES=$(crsctl status resource -w "(TYPE == ora.database.type)"|grep NAME=|sed s'/NAME=//')

	crsctl status resource -w "(TYPE == ora.database.type)"|grep NAME=|sed s'/NAME=//' | while read -r dbres
	do
        	var_dbres=`echo $dbres | sed s':\n::g' | sed s': ::g'`
        	var_db_unique_name=`echo $var_dbres | sed -r 's/^.{4}//' | sed -r 's/.{3}$//'` 
        	var_db_instances=$(get_instances $var_dbres)
        	var_db_local_instance=$(get_local_instance $var_dbres)
		if [ -n "$var_db_local_instance" ]; then
        		echo "Listing details for database resource: $var_dbres"
			echo "----------------------------------------------------------------------------------------------------------------------------"
			echo -e " Db_unique_name  : \e[1m$var_db_unique_name \e[0m(Local instance: $var_db_local_instance)"
			echo " Other instances : $var_db_instances"
			echo ""
		fi
	done

}


###########################################################################################
#                                                                                         #
# Main section of this scrip                                                              #
#                                                                                         #
###########################################################################################

#
# Determine how to suppress newline with echo command.
#
N=
C=
if echo "\c" | grep c >/dev/null 2>&1; then
    N='-n'
else
    C='\c'
fi


# Set the environment to access the cluster
set_grid_env

# Check is script is being used to set ASM environment
if [[ $1 == +AS* ]]; then

        echo "Script does not currently support ASM instances. Please use oasm command instead"
        kill -INT $$
fi



if [ -n "$DBNAME" ]; then

	DBNAME2=`crsctl status resource -w "(TYPE == ora.database.type)"|grep NAME=|sed s'/NAME=//' | sed -r 's/^.{4}/+/' | sed -r 's/.{3}$/+/'|grep +$DBNAME+`

	# Check the provided db_unique_name is valid
	if [ -n "$DBNAME2" ]; then

        	#echo "Setting environment for database: $DBNAME"
		RES="ora.$1.db"
  		DB_UNIQUE_NAME=`echo $RES|sed s'/ora.//'|sed s'/.db//'`
		ORACLE_HOME=$(get_oracle_home $RES)
		INSTANCE=$(get_local_instance $RES)

		#echo "DB_UNIQUE_NAME   : $DB_UNIQUE_NAME"
		#echo "Cluster ressource: $RES"
		#echo "ORACLE_HOME      : $ORACLE_HOME"
		#echo "INSTANCE_NAME    : $INSTANCE"

		set_ora_env $INSTANCE $ORACLE_HOME $DB_UNIQUE_NAME
	else
		# The provided db_unique_name does not match any database in the cluster
		echo "The provided db_unique_name does not match any database in the cluster."
		kill -INT $$
	fi
else
	
	# List all databases in cluster
	list_resources


	echo ""
	echo "Please enter the db_unique_name of one of the above databases: ? "
	echo "Notice: Databases with running instances on tihs server have"
	echo "their local instance listed above."
        echo "=============================================================="
	echo $N "DB_UNIQUE_NAME = [] ? $C"
	read IN_DBNAME

	DBNAME2=`crsctl status resource -w "(TYPE == ora.database.type)"|grep NAME=|sed s'/NAME=//' | sed -r 's/^.{4}/+/' | sed -r 's/.{3}$/+/'|grep +$IN_DBNAME+`

	if [ -n "$DBNAME2" ]; then


		echo ""
        	#echo "Setting environment for database: $IN_DBNAME"
        	RES="ora.$IN_DBNAME.db"
        	DB_UNIQUE_NAME=`echo $RES|sed s'/ora.//'|sed s'/.db//'`
        	ORACLE_HOME=$(get_oracle_home $RES)
        	INSTANCE=$(get_local_instance $RES)

        	#echo "DB_UNIQUE_NAME   : $DB_UNIQUE_NAME"
        	#echo "Cluster ressource: $RES"
        	#echo "ORACLE_HOME      : $ORACLE_HOME"
        	#echo "INSTANCE_NAME    : $INSTANCE"

        	set_ora_env $INSTANCE $ORACLE_HOME $DB_UNIQUE_NAME
	else
	        # The provided db_unique_name does not match any database in the cluster
                echo "The provided db_unique_name does not match any database in the cluster."
                kill -INT $$
	fi
fi

