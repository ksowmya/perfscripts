#!/bin/bash
dbhost=$1
count=1
while [ $count -ne 0 ]
do
	sleep 10s
	count=`mysql -U cloud -h $dbhost --skip-column-names -e "select count(*) from async_job where job_status=0"`
	echo $(date) ":" $count
done
count=1
echo $(date) " : Waiting for security rules to be done"
x=$(date +%s)
while [ $count -ne 0 ]
do
	sleep 10s
	count=`mysql -U cloud -h $dbhost --skip-column-names -e "select count(*) from op_nwgrp_work where step not in ('Error','Done')"`
	echo $(date) ":" $count
done
y=$(date +%s)
echo $(date) " : Done Waiting for security rules to be done"
let z=$y-$x
echo "Time Spent waiting for SG rules : " $z
