
  #
  # Copyright (C) 2011 Cloud.com, Inc.  All rights reserved.
  #
 

x=$1

start_vm="GET  http://10.91.30.219:8096/client/?command=startVirtualMachine&id=$x	HTTP/1.0\n\n"


echo -e $start_vm | nc -v -q 60 10.91.30.219 8096

