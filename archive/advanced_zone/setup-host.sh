#!/bin/bash



  #
  # Copyright (C) 2011 Cloud.com, Inc.  All rights reserved.
  #
 

#setup for Guava hosts in the simulator

#1 host per cluster
#2 clusters per pod
#3 40 vms per host
#4 40 vms per account

mgmtServer=$1
count=$2
podCount=1
accountCount=$(($count/40))

zone_query="GET  http://$mgmtServer/client/?command=createZone&networktype=Advanced&securitygroupenabled=false&name=Go&dns1=4.2.2.2&internaldns1=4.2.2.2&vlan=500-1750&guestcidraddress=10.1.1.0%2F24	HTTP/1.0\n\n"
echo -e $zone_query | nc -v -w 120 $mgmtServer 8096

#Add Secondary Storage
sstor_query="GET  http://$mgmtServer/client/?command=addSecondaryStorage&zoneid=1&url=nfs://172.16.15.32/export/share/secondary  HTTP/1.0\n\n"
echo -e $sstor_query | nc -v -w 120 $mgmtServer 8096

vlan_query="GET http://$mgmtServer/client/?command=createVlanIpRange&forVirtualNetwork=true&zoneId=1&vlan=untagged&gateway=172.120.1.1&netmask=255.255.0.0&startip=172.120.1.2&endip=172.120.255.254	HTTP/1.0\n\n"
echo -e $vlan_query | nc -v -w 120 $mgmtServer 8096

x=1
for name in `seq 1 $podCount`
do
    pod_query="GET  http://$mgmtServer/client/?command=createPod&zoneId=1&name=Guava$x&netmask=255.255.0.0&startIp=172.$x.2.2&endIp=172.$x.255.252&gateway=172.$x.2.1	HTTP/1.0\n\n"
    pod_out=$(echo -e $pod_query | nc -v -w 120 $mgmtServer 8096)
    pod_id=$(echo $pod_out | sed 's/\(.*<id>\)\([0-9]*\)\(.*\)/\2/g')
    if ! [[ "$pod_id" =~ ^[0-9]+$ ]] ; then
       exec >&2; echo "[ERROR] $(date) pod [POD$name] creation failed"; continue
    fi

	cluster_query="GET http://$mgmtServer/client/?command=addCluster&hypervisor=Simulator&clustertype=CloudManaged&zoneId=1&podId=$pod_id&clustername=CS$name	HTTP/1.0\n\n"
	cluster_out=$(echo -e $cluster_query | nc -v -w 120 $mgmtServer 8096)
        cluster_id=$(echo $cluster_out | sed 's/\(.*<id>\)\([0-9]*\)\(.*\)/\2/g')
        if ! [[ "$cluster_id" =~ ^[0-9]+$ ]] ; then
           exec >&2; echo "[ERROR] $(date) cluster[POD$name-CLUSTER$cluster] creation for pod[POD$name] failed"; continue
        fi

	for j in `seq 1 $count`
	do
		host_query="GET	http://$mgmtServer/client/?command=addHost&zoneId=1&podId=$pod_id&clusterid=$cluster_id&hypervisor=Simulator&clustertype=CloudManaged&hosttags=&username=sim&password=sim&url=http%3A%2F%2Fsim	HTTP/1.0\n\n"
		echo -e $host_query | nc -v -w 60 $mgmtServer 8096

	done
	spool_query="GET http://$mgmtServer/client/?command=createStoragePool&zoneId=1&podId=$pod_id&clusterid=$cluster_id&name=SPOOL$name&url=nfs://172.1.25.$name/export/share/$name   HTTP/1.0\n\n"
	echo -e $spool_query | nc -v -w 60 $mgmtServer 8096

	let x+=1
done
./createServiceOfferings.sh $mgmtServer
./createUserAccount.sh $mgmtServer $accountCount
./deployVirtualMachine.sh $mgmtServer $count
