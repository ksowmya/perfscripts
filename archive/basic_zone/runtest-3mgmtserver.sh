host=10.223.75.131
vmCount=2000
sg=1
batchCount=500
dbhost=10.223.75.135
batchesResp=100

./setup-sg.sh -h $host -z 1 -d 300 -n $vmCount
./createServiceOfferings.sh $host
./deployBulk-wait-sg.sh -h $host -n 1000 -w $batchCount -d $dbhost -s $sg -o 10 -t 10
./vmtime.sh $dbhost 1 1000 $batchesResp
sleep 180s
./deployBulk-wait-sg.sh -h $host -n 1000 -w $batchCount -d $dbhost -s $sg -o 10 -t 10
./vmtime.sh $dbhost 1001 2000 $batchesResp
