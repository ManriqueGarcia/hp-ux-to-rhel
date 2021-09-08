#!/bin/bash

workdir=/tmp/hpux2rhel


function showhelp() {
    echo "Help"
    echo "hpux2rhel [-u] [-g] [-m] [-a] SOURCEHOST"
    echo "-u to migrate only users"
    echo "-g to migrate only groups"
    echo "-m to migrate home users"
    echo "-a to migrate all (users, groups, and homes)"
}

function check_workdir () {
    
    if [ -d ${workdir} ]
      then
        echo "Workdir exists"
      else
        mkdir -p ${workdir}
    fi

}

function migrate_user() {
    echo "Migrating users"
    scp -v -P 33722 ${1}:/etc/passwd ${workdir}/hpux-passwd
    cp -v /etc/passwd ${workdir}/rhel-passwd
    awk -F: '{ if ($3 > 500) { print $0}}' ${workdir}/hpux-passwd >> ${workdir}/rhel-passwd
    cp -v /etc/passwd ${workdir}/passwd.bak
    cp -v ${workdir}/rhel-passwd /etc/passwd
    pwconv

}

function migrate_groups() {
    echo "migrating groups"
    scp -v -P 33722 ${1}:/etc/groups ${workdir}/hpux-groups
    cp -v /etc/groups ${workdir}/rhel-groups
    awk -F: '{ if ($3 > 500) { print $0}}' ${workdir}/hpux-groups >> ${workdir}/rhel-groups
    cp -v /etc/groups ${workdir}/groups.bak
    cp -v ${workdir}/rhel-groups /etc/groups
}

function migrate_home() {
    echo "migrating home users"
}

function migrate_all() {
    echo "migrate all"
}
VERBOSE=0
HOST=


while getopts "ugmavh" opt
do
  case "$opt" in
    u) m_user=1;;
    g) m_grou=1;;
    m) m_home=1;;
    a) m_all=1;;
    v) (( VERBOSE++ ));;
    h|*) showhelp && exit 0;;
  esac
done

shift $(( OPTIND - 1 ))

#name=${1:?$( showhelp )}

if [ -z "${1}" ]
 then 
   showhelp
   echo "Hostname is missing"
   exit 0
fi

check_workdir

if [ "${m_user}" == "1" ]
  then 
    migrate_user "$@"
fi


