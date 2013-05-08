#!/bin/bash



  #
  # Copyright (C) 2011 Cloud.com, Inc.  All rights reserved.
  #
 
mgmtServer=$1
count=$2

	for j in `seq 1 $count`
	do
		host_query="GET	http://$mgmtServer/client/?command=addHost&zoneId=1&podId=1&clusterid=1&hypervisor=Simulator&clustertype=CloudManaged&hosttags=&username=sim&password=sim&url=http%3A%2F%2Fsim	HTTP/1.0\n\n"
		echo -e $host_query | nc -v -w 60 $mgmtServer 8096

	done
