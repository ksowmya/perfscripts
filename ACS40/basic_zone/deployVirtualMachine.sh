#!/bin/bash
  #
  # Copyright (C) 2011 Cloud.com, Inc.  All rights reserved.
  #
  
usage() {
  printf "Deploy Virtual Machine Usage: %s: -h management-server -z zoneid [-d domainid] [-u with-user-data] -a account -t templateid -s service-offering-id [-g securitygroup list]\n" $(basename $0) >&2
}

zflag=
hflag=
sflag=
tflag=
dflag=1
aflag=1
uflag=
gflag=1

zoneid=
templateId=
serviceOfferingId=
domainid=1
host="127.0.0.1" #defaults to locahost
account="admin" #defaults to admin
sglist=

while getopts 'uh:z:d:t:s:a:g:' OPTION
do
 case $OPTION in
  h)	hflag=1
        host="$OPTARG"
        ;;
  z)    zflag=1
        zoneid="$OPTARG"
        ;;    
  d)    dflag=1
        domainid="$OPTARG"
        ;;
  s)    sflag=1
        serviceOfferingId="$OPTARG"
        ;;
  t)    tflag=1
        templateId="$OPTARG"
        ;;
  a)    aflag=1
        account="$OPTARG"
        ;;
  g)    gflag=1
        sglist="$OPTARG"
        ;;          
  u)    uflag=1        
        ;;                
  ?)	usage
		exit 2
		;;
  esac
done

if [[ $zflag$sflag$tflag != "111" ]]
then
 usage
 exit 2
fi

if [[ $uflag == "1" ]]
then
    query="GET	http://$host:8096/client/?command=deployVirtualMachine&hypervisor=Simulator&zoneId=$zoneid&templateId=$templateId&serviceOfferingId=$serviceOfferingId&securitygroupids=$sglist&account=$account&domainid=$domainid&userdata=U29uZyBUbyBCZSBTdW5nIGJ5IHRoZSBGYXRoZXIgb2YgSW5mYW50IEZlbWFsZSBDaGlsZHJlbgpieSBPZ2RlbiBOYXNoCgpNeSBoZWFydCBsZWFwcyB1cCB3aGVuIEkgYmVob2xkCkEgcmFpbmJvdyBpbiB0aGUgc2t5OwpDb250cmFyaXdpc2UsIG15IGJsb29kIHJ1bnMgY29sZApXaGVuIGxpdHRsZSBib3lzIGdvIGJ5LgpGb3IgbGl0dGxlIGJveXMgYXMgbGl0dGxlIGJveXMsCk5vIHNwZWNpYWwgaGF0ZSBJIGNhcnJ5LApCdXQgbm93IGFuZCB0aGVuIHRoZXkgZ3JvdyB0byBtZW4sCkFuZCB3aGVuIHRoZXkgZG8sIHRoZXkgbWFycnkuCk5vIG1hdHRlciBob3cgdGhleSB0YXJyeSwKRXZlbnR1YWxseSB0aGV5IG1hcnJ5LgpBbmQsIHN3aW5lIGFtb25nIHRoZSBwZWFybHMsClRoZXkgbWFycnkgbGl0dGxlIGdpcmxzLgoKT2gsIHNvbWV3aGVyZSwgc29tZXdoZXJlLCBhbiBpbmZhbnQgcGxheXMsCldpdGggcGFyZW50cyB3aG8gZmVlZCBhbmQgY2xvdGhlIGhpbS4KVGhlaXIgbGlwcyBhcmUgc3RpY2t5IHdpdGggcHJpZGUgYW5kIHByYWlzZSwKQnV0IEkgaGF2ZSBiZWd1biB0byBsb2F0aGUgaGltLgpZZXMsIEkgbG9hdGhlIHdpdGggbG9hdGhpbmcgc2hhbWVsZXNzClRoaXMgY2hpbGQgd2hvIHRvIG1lIGlzIG5hbWVsZXNzLgpUaGlzIGJhY2hlbG9yIGNoaWxkIGluIGhpcyBjYXJyaWFnZQpHaXZlcyBuZXZlciBhIHRob3VnaHQgdG8gbWFycmlhZ2UsCkJ1dCBhIHBlcnNvbiBjYW4gaGFyZGx5IHNheSBrbmlmZQpCZWZvcmUgaGUgd2lsbCBodW50IGhpbSB	HTTP/1.0\n\n" 
else
    query="GET	http://$host:8096/client/?command=deployVirtualMachine&hypervisor=Simulator&zoneId=$zoneid&templateId=$templateId&serviceOfferingId=$serviceOfferingId&securitygroupids=$sglist&account=$account&domainid=$domainid	HTTP/1.0\n\n" 
fi
x=$(date +%s)
echo $query
echo -e $query | nc -v -w 300 $host 8096
y=$(date +%s)
let z=$y-$x
echo "Response Time(in secs) : " $z " current Time: " $(date)
