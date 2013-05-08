host=$1
serviceOffering="http://$host:8096/client/?command=createServiceOffering&name=SO1&displayText=SO1&storageType=local&cpuNumber=1&cpuSpeed=512&memory=6500&offerha=false&usevirtualnetwork=false&hosttags=TAG1"
wget $serviceOffering
serviceOffering="http://$host:8096/client/?command=createServiceOffering&name=SO2&displayText=SO2&storageType=local&cpuNumber=1&cpuSpeed=512&memory=6500&offerha=false&usevirtualnetwork=false&hosttags=TAG2"
wget $serviceOffering
serviceOffering="http://$host:8096/client/?command=createServiceOffering&name=SO3&displayText=SO3&storageType=local&cpuNumber=1&cpuSpeed=512&memory=6500&offerha=false&usevirtualnetwork=false&hosttags=TAG3"
wget $serviceOffering
