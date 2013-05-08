#
# Copyright (C) 2011 Cloud.com, Inc.  All rights reserved.
#
mgmtServer=$1
count=$2

for name in `seq 1 $count`
do

account_query="GET	http://$mgmtServer/client/?command=createAccount&accounttype=0&email=simulator%40simulator.com&username=test$name&firstname=first$name&lastname=last$name&password=5f4dcc3b5aa765d61d8327deb882cf99&account=test$name&domainid=1	HTTP/1.1\n\n"

echo -e $account_query | nc -v -w 120 $mgmtServer 8096

updateResource_query="GET http://$mgmtServer/client/?command=updateResourceLimit&domainid=1&account=test$name&resourceType=0&max=50 HTTP/1.1\n\n"

echo -e $updateResource_query | nc -v -w 120 $mgmtServer 8096
done
