# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
unalias ls 2>/dev/null
unalias vi 2>/dev/null

export ORATAB=/etc/oratab
alias oratab='cat /etc/oratab'
alias pmon='ps -ef|grep pmon'
alias tns='cd $ORACLE_HOME/network/admin'
alias dbs='cd $ORACLE_HOME/dbs'
alias sid='echo $ORACLE_SID'

alias calxt='export ORACLE_SID=dm11calxt1; export ORAENV_ASK=NO; . oraenv; export ORAENV_ASK=YES'
alias calxp='export ORACLE_SID=dm11calxp1; export ORAENV_ASK=NO; . oraenv; export ORAENV_ASK=YES'
alias dbm11p='export ORACLE_SID=dbm11p1; export ORAENV_ASK=NO; . oraenv; export ORAENV_ASK=YES'
alias niorxp='export ORACLE_SID=dm11niorxp1; export ORAENV_ASK=NO; . oraenv; export ORAENV_ASK=YES'
alias niorp='export ORACLE_SID=niorx1p; export ORAENV_ASK=NO; . oraenv; export ORAENV_ASK=YES;export ORACLE_SID=dm11niorxp1'
alias fsx4p='export ORACLE_SID=fsx4ph; export ORAENV_ASK=NO; . oraenv; export ORAENV_ASK=YES; export ORACLE_SID=fsx4ph1'
alias bsip='export ORACLE_SID=bsiph; export ORAENV_ASK=NO; . oraenv; export ORAENV_ASK=YES; export ORACLE_SID=bsiph1'

#export ORACLE_SID=dbm11p1
#export ORAENV_ASK=NO
#. oraenv
#export ORAENV_ASK=YES

export RAT_TIMEOUT=200
export RAT_ROOT_TIMEOUT=500
export RAT_PASSWORDCHECK_TIMEOUT=200
oe()
{

if [[ $1 != "" ]]
then
        ORACLE_SID=$1
        ORAENV_ASK=NO
        . oraenv
        ORAENV_ASK=YES

        SID=`ps -u oracle -o args |grep ora_[p]mon_$1| sed 's/^ora_pmon_//'`

        export ORACLE_SID=$SID
else
        echo 'usage oe <db-unique-name>'

fi
env|grep ORA

}

