host=10.223.41.6
vmCount=5000
sg=3
batchCount=500
dbhost=10.223.41.5
batchesResp=100

./setup-sg-3.0.sh -h $host -z 1 -d 300 -n $vmCount
./createServiceOfferings.sh $host
./deployBulk-wait-sg.sh -h $host -n 1000 -w $batchCount -d $dbhost -s $sg -o 11 -t 10
./vmtime.sh $dbhost 1 1000 $batchesResp
sleep 180s
./deployBulk-wait-sg.sh -h $host -n 1000 -w $batchCount -d $dbhost -s $sg -o 11 -t 10
./vmtime.sh $dbhost 1001 2000 $batchesResp
sleep 180s
./deployBulk-wait-sg.sh -h $host -n 1000 -w $batchCount -d $dbhost -s $sg -o 11 -t 10
./vmtime.sh $dbhost 2001 3000 $batchesResp
sleep 180s
./deployBulk-wait-sg.sh -h $host -n 1000 -w $batchCount -d $dbhost -s $sg -o 11 -t 10
./vmtime.sh $dbhost 3001 4000 $batchesResp
sleep 180s
./deployBulk-wait-sg.sh -h $host -n 1000 -w $batchCount -d $dbhost -s $sg -o 11 -t 10
./vmtime.sh $dbhost 4001 5000 $batchesResp
