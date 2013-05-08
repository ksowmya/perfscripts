#!/bin/bash

  #
  # Copyright (C) 2011 Cloud.com, Inc.  All rights reserved.
  #

############################################################
#
# This setup uses local storage, before setting up make sure
#     * xen.public.network.device is set
#     * use.local.storage and systemvm.use.local.storage are true
#     * optionally turn off stats collectors
#     * expunge.delay and expunge.interval are 60s
#     * ping.interval is around 3m
#     * turn off dns updates to entire zone, network.dns.basiczone.update=pod
#     * capacity.skipcounting.hours=0
#     * direct.agent.load.size=1000

#
#   This script will only setup an approximate number of hosts. To achieve the ratio
#   of 5:2:6 hosts the total number of hosts is brought close to a number divisible
#   by 13. So if 4000 hosts are added, you might see only 3900 come up
#   
#   10 hosts per pod @ 1 host per cluster in a single zone
#   
#   Each pod has a /25, so 128 addresses. I think we reserved 5 IP addresses for system VMs in each pod. 
#   Then we had something like 60 addresses for hosts and 60 addresses for VMs.
   
#Environment
#1. Approximately 10 hosts per pod. 
#2. Only 3 host tags. 
#3. With in each pod, the host tags are the same. Homogenous Pods
#4. The ratio of hosts for the three tags should be 5/2/6
#5. In simulator.properties, workers=1
############################################################

usage() {
  printf "Setup Basic Like Environment\nUsage: %s: -h management-server -z zoneid [-d delay] -n numberofhosts\n" $(basename $0) >&2
}

a=1 #CIDR - 16bytes
b=2 #CIDR - 8 bytes

#options
hflag=1
zflag=
dflag=1
nflag=1

host="127.0.0.1" #default localhost
zoneid=
delay=300 #default 5 minutes
numberofhosts=1300 #default 1300 hosts
tag[1]="TAG1"
tag[2]="TAG1"
tag[3]="TAG1"
tag[4]="TAG1"
tag[5]="TAG1"
tag[6]="TAG2"
tag[7]="TAG2"
tag[8]="TAG3"
tag[9]="TAG3"
tag[10]="TAG3"
tag[11]="TAG3"
tag[12]="TAG3"
tagIndex=1

while getopts 'h:z:d:n:' OPTION
do
 case $OPTION in
  h)	hflag=1
        host="$OPTARG"
        ;;
  z)    zflag=1
        zoneid="$OPTARG"
        ;;    
  d)    dflag=1
        delay="$OPTARG"
        ;;
  n)    nflag=1
        numberofhosts="$OPTARG"
        ;;
  ?)	usage
		exit 2
		;;
  esac
done

if [ $zflag$nflag != "11" ]
then
 usage
 exit 2
fi

numberofpods=$(($numberofhosts/10)) #10 hosts per pod

clusters_per_pod=10 #each cluster has one host
hosts_per_pod=10


declare -a pod_array
declare -a cluster_array


#create the zone
#zone_query="GET  http://$host/client/?command=createZone&networktype=Basic&securitygroupenabled=true&name=Basic&dns1=4.2.2.2&internaldns1=4.2.2.2  HTTP/1.0\n\n"
#echo -e $zone_query | nc -v -w $delay $host 8096

#physicalNetwork_query="GET http://$host/client/?command=createPhysicalNetwork&zoneid=1&name=Physical_Network_1 HTTP/1.0\n\n"
#echo -e $physicalNetwork_query | nc -v -w $delay $host 8096

#addmgmttraffictype_query="GET http://$host/client/?command=addTrafficType&trafficType=Management&physicalnetworkid=1 HTTP/1.0\n\n"
#echo -e $addmgmttraffictype_query | nc -v -w $delay $host 8096

#addguesttraffictype_query="GET http://$host/client/?command=addTrafficType&trafficType=Guest&physicalnetworkid=1 HTTP/1.0\n\n"
#echo -e $addguesttraffictype_query | nc -v -w $delay $host 8096

#update_physicalNetwork_query="GET http://$host/client/?command=updatePhysicalNetwork&state=Enabled&id=1 HTTP/1.0\n\n"
#echo -e $update_physicalNetwork_query | nc -v -w $delay $host 8096

listNetworkServiceProviders_query="GET http://$host/client/?command=listNetworkServiceProviders&name=VirtualRouter&physicalNetworkId=1 HTTP/1.0\n\n"
echo $listNetworkServiceProviders_query
listNetworkServiceProviders_out=$(echo -e $listNetworkServiceProviders_query  | nc -v -w $delay $host 8096)
echo $listNetworkServiceProviders_out
nsp_id=$(echo $listNetworkServiceProviders_out | sed 's/\(.*<id>\)\(.*\)\(<\/id>.*\)/\2/g')

listVirtualRouterElements_query="GET http://$host/client/?command=listVirtualRouterElements&nspid=$nsp_id HTTP/1.0\n\n"
echo $listVirtualRouterElements_query
listVirtualRouterElements_out=$(echo -e $listVirtualRouterElements_query  | nc -v -w $delay $host 8096)
echo $listVirtualRouterElements_out
vr_id=$(echo $listVirtualRouterElements_out | sed 's/\(.*<id>\)\(.*\)\(<\/id>.*\)/\2/g')

configureVirtualRouterElement_query="GET http://$host/client/?command=configureVirtualRouterElement&enabled=true&id=$vr_id HTTP/1.0\n\n"
echo -e $configureVirtualRouterElement_query | nc -v -w $delay $host 8096

updateNetworkServiceProvider_vr_query="GET http://$host/client/?command=updateNetworkServiceProvider&state=Enabled&id=$nsp_id HTTP/1.0\n\n"
echo -e $updateNetworkServiceProvider_vr_query | nc -v -w $delay $host 8096

listNetworkServiceProviders_query="GET http://$host/client/?command=listNetworkServiceProviders&name=SecurityGroupProvider&physicalNetworkId=1 HTTP/1.0\n\n"
echo $listNetworkServiceProviders_query
listNetworkServiceProviders_out=$(echo -e $listNetworkServiceProviders_query  | nc -v -w $delay $host 8096)
echo $listNetworkServiceProviders_out
nsp_id=$(echo $listNetworkServiceProviders_out | sed 's/\(.*<id>\)\(.*\)\(<\/id>.*\)/\2/g')

updateNetworkServiceProvider_sg_query="GET http://$host/client/?command=updateNetworkServiceProvider&state=Enabled&id=$nsp_id HTTP/1.0\n\n"
echo -e $updateNetworkServiceProvider_sg_query | nc -v -w $delay $host 8096

createNetwork_query="GET http://$host/client/?command=createNetwork&zoneid=1&name=guestNetworkForBasicZone&displaytext=guestNetworkForBasicZone&networkofferingid=5 HTTP/1.0\n\n"
echo -e $createNetwork_query | nc -v -w $delay $host 8096

updateZone_query="GET http://$host/client/?command=updateZone&allocationstate=Enabled&id=1 HTTP/1.0\n\n"
echo -e $updateZone_query | nc -v -w $delay $host 8096

#Add Secondary Storage
sstor_query="GET http://$host/client/?command=addSecondaryStorage&zoneid=$zoneid&url=nfs://172.16.15.32/export/share/secondary  HTTP/1.0\n\n"
echo -e $sstor_query | nc -v -w $delay $host 8096

