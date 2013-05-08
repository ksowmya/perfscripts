#!/bin/bash

  #
  # Copyright (C) 2011 Cloud.com, Inc.  All rights reserved.
  #
  
usage() {
  printf "Deploy many VMs: %s: -h management-server -n numberofvms [[-g number of security groups] [-p max sec.groups per vm]]\n" $(basename $0) >&2
  printf "The -g option when given, VMs will be provisioned into security groups. The -p option specifies the maximum number of security groups
   that a VM can be provisioned in. Default value is 1 per vm.\n"
}

hflag=
nflag=1
gflag=
pflag=1
sflag=0

host="127.0.0.1" #defaults to locahost
numberofvms=1040 #defaults
numberofgroups= 
groups_per_vm=1 #default one group per vm

waitcount=10
templateId="2"
tagId=9
accountId="admin"

while getopts 'h:n:w:d:s:u:t:o:a:' OPTION
do
	case $OPTION in
		h)	  hflag=1
			host="$OPTARG"
			;;
		n)    nflag=1
			numberofvms="$OPTARG"
			;;
		w)    wflag=1
			waitcount="$OPTARG"
			;;
		d)	  dflag=1
			dbhost="$OPTARG"
			;;
		a)	  aflag=1
			accountId="$OPTARG"
			;;
		s)	  sflag=1
			sg="$OPTARG"
			;;
		t)  	templateId="$OPTARG"
			;;
		o)  	tagId="$OPTARG"
			;;
		?)	usage
			exit 2
			;;
	esac
done

if [ $hflag$nflag$wflag$dflag != "1111" ]
then
 usage
 exit 2
fi

tag1_so=$tagId
tag2_so=$(($tagId+1))
tag3_so=$(($tagId+2))

tag[1]=$tag1_so
tag[2]=$tag1_so
tag[3]=$tag1_so
tag[4]=$tag1_so
tag[5]=$tag1_so
tag[6]=$tag2_so
tag[7]=$tag2_so
tag[8]=$tag3_so
tag[9]=$tag3_so
tag[10]=$tag3_so
tag[11]=$tag3_so
tag[12]=$tag3_so
tagIndex=1

vmcount=1
for ((c=0;c<$numberofvms;c++))
do
	
        if [ "$vmcount" -eq $waitcount ]
        then
	     echo "Sleeping until all Vms are done"
	     ./waitForScheduled.sh $dbhost
             vmcount=1
        else
              vmcount=$(($vmcount+1))
        fi

	echo "TemplateId Used :" $templateId

	if [ "$sflag" -eq "1" ]
	then
        	./deployVirtualMachine.sh -h $host -z 1 -t $templateId -s ${tag[$tagIndex]} -u -g $sg -a $accountId &
	else
        	./deployVirtualMachine.sh -h $host -z 1 -t $templateId -s ${tag[$tagIndex]} -u -a $accountId &
	fi

	if [ "$tagIndex" -eq 12 ]
        then
            tagIndex=1
        else
            tagIndex=$(($tagIndex+1))
        fi

done
	     ./waitForScheduled.sh $dbhost
