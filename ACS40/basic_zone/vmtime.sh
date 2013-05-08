#!/bin/bash
startRange=84
endRange=1081
step=100

dbhost=$1
startRange=$2
endRange=$3
step=$4

mysql -U cloud -h $dbhost -e "select count(*),state,type from vm_instance group by state,type" 

while [ $startRange -lt $endRange ]
do
let endRangeComputed=startRange+step
echo "VM Response time for job ids between" $startRange ":" $endRangeComputed
mysql -U cloud -h $dbhost --skip-column-names -e "select avg(timestampdiff(second,created,last_updated)),min(timediff(last_updated ,created)),max(timediff(last_updated ,created)),count(id),job_status, min(created),max(created) from async_job where last_updated is not null and id >= $startRange and id < $endRangeComputed group by job_status"
let startRange=endRangeComputed
done
