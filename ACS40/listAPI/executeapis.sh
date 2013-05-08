#!/bin/bash

help()
{
cat << EOF
usage: $0 options
Script to execute the list of apis from a file.
 
OPTIONS:
    -f      file containing the list of apis to execute
    -m	    management server  
    -a      api key
    -s      secret key
    -h      print this help
EOF
}
apifile=
hostname=
apikey=
secretkey=

while getopts "hf:m:a:s:" option
do
   case $option in
	f) apifile="$OPTARG"
	   ;;
	m) hostname="$OPTARG"
	   ;;
	a) apikey="$OPTARG"
	   ;;
	s) secretkey="$OPTARG"
	   ;;
	?) help
	   exit 2
	   ;;
	h) help
	   exit 1
	   ;;
   esac 	
done

if [-z $apifile || -z $hostname || -z $apikey || -z $secretkey ]; help

while read line
do
	echo $line
	command=`echo $line | cut -d '&' -f1`
        params=`echo $line | cut -d '&' -f2-`
	signed_api=`python ./sign_api.py ${command} ${params} ${apikey} ${secretkey}`
	echo "command: $command, params: $params, apikey: $apikey, seckey: $secretkey"
	api="http://$hostname:8080/client/api?command=$command&${params}&apikey=${apikey}&signature=${signed_api}"
	echo $api
	(time wget -O $line.out $api) 2>> time.out
done < $apifile
