#!/bin/bash

  #
  # Copyright (C) 2011 Cloud.com, Inc.  All rights reserved.
  #
 

zoneid=1
templateId=10
serviceOfferingId=10
account="test"
mgmtServer=$1
count=$2

for j in `seq 1 $count` 
	do
		query="GET	http://$mgmtServer/client/?command=deployVirtualMachine&zoneId=$zoneid&hypervisor=Simulator&templateId=$templateId&serviceOfferingId=$serviceOfferingId	HTTP/1.0\n\n"
 
		echo -e $query | nc -v -w 20 $mgmtServer 8096
done
