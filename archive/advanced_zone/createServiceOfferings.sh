host=$1
serviceOffering="http://$host:8096/client/?command=createServiceOffering&name=SO1&displayText=SO1&storageType=shared&cpuNumber=1&cpuSpeed=512&memory=180&offerha=false&usevirtualnetwork=true"
wget $serviceOffering
