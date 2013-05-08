#
# Copyright (C) 2011 Cloud.com, Inc.  All rights reserved.
#
mgmtServer=$1
count=$2
noId="9384dab9-d19d-4b2d-bf28-d545787dcaeb"
zoneid="ec7df848-5880-4b81-8e45-e2d8b8382414"

#count=$(($count+4004))
echo $count


for name in `seq 1 $count`
#for name in `seq 4001 $count`
do

account_query="GET	http://$mgmtServer/client/?command=createAccount&accounttype=0&email=simulator%40simulator.com&username=test$name&firstname=first$name&lastname=last$name&password=5f4dcc3b5aa765d61d8327deb882cf99&account=test$name&domainid=1	HTTP/1.1\n\n"
echo -e $account_query | nc -v -w 120 $mgmtServer 8096

#createNetwork_query="GET http://$mgmtServer/client/?command=createNetwork&networkOfferingId=$noId&name=test$name&displayText=test$name&zoneId=1&&account=test$name&domainid=1 HTTP/1.0\n\n"
createNetwork_query="GET http://$mgmtServer/client/?command=createNetwork&networkOfferingId=$noId&name=test$name&displayText=test$name&zoneId=$zoneid&account=test$name&domainid=1 HTTP/1.0\n\n"

createNetwork_out=$(echo -e $createNetwork_query | nc -v -w 120 $mgmtServer 8096)
network_id=$(echo $createNetwork_out | sed 's/\(.*<id>\)\(.*\)\(<\/id>.*\)/\2/g')
echo $network_id


#updateResource_query="GET http://$mgmtServer/client/?command=updateResourceLimit&domainid=1&account=test$name&resourceType=0&max=50 HTTP/1.1\n\n"

#echo -e $updateResource_query | nc -v -w 120 $mgmtServer 8096
done
