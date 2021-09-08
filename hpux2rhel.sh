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
        mkdir ${workdir}
    fi

}

function migrate_user() {
    echo "Migrating users"
    echo "$1"

}

function migrate_groups() {
    echo "migrating groups"
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

if [ "${m_user}" == "1" ]
  then 
    migrate_user "$@"
fi

