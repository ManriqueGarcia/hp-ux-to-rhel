#!/bin/bash
## Script to create csv with passwd and shadow files

WORKDIR="../workdir"
HPPASSWD=${WORKDIR}/hpux-passwd
HPSHADOW=${WORKDIR}/hpux-shadow
USERSFILE=${WORKDIR}/users.csv

#list users

for user in $( awk -F: '{ if ( $3 > 200 && $3 != 777) {print $1}}' ${HPPASSWD});do
   USER=$(grep ${user} ${HPPASSWD}|sed 's/:/,/g')
   PASS=$(awk -F: -v username=${user} '{ if ($1 == username) {print $2}}' ${HPSHADOW})
 
   echo "${USER},${PASS}" >> ${USERSFILE}
done
