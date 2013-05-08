#!/bin/bash

  #
  # Copyright (C) 2011 Cloud.com, Inc.  All rights reserved.
  #
 

#zoneid=1
#templateId=10
#serviceOfferingId=11
account="test"
mgmtServer=$1
count=$2
zoneid="98f881d2-9296-4f51-a704-30c9ea2b0119"
templateId="688fef36-8c86-11e2-9f30-00e081790096"
serviceOfferingId="b61f813f-126f-4d50-9865-bb62b97962d9"

#accountCount=$(($count/5))
#accountCount=$(($count/3))
accountCount=4000

echo "No of Accounts :" $accountCount

for i in `seq 1 $accountCount`
do
	listNetwork_query="GET http://$mgmtServer/client/?command=listNetworks&account=$account$i&domainid=1 HTTP/1.1\n\n"
	listNetwork_out=$(echo -e $listNetwork_query | nc -v -w 120 $mgmtServer 8096)
	network_id=$(echo $listNetwork_out | sed 's/\(.*<id>\)\(.*\)\(<\/id>.*\)/\2/g')
	echo $network_id

	for j in `seq 1 3`
	do
		query="GET	http://$mgmtServer/client/?command=deployVirtualMachine&zoneId=$zoneid&hypervisor=Simulator&templateId=$templateId&serviceOfferingId=$serviceOfferingId&networkids=$network_id&account=$account$i&domainid=1	HTTP/1.1\n\n"
 
		echo -e $query | nc -v -w 120 $mgmtServer 8096
	done
	sleep 0.2
done

