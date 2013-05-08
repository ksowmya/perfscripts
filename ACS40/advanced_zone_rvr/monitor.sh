while :
do
        echo $(date) >> monitor.out
        conn=`netstat -ant | grep 3306 | grep 10.102.192.9 | grep ESTABLISHED |   wc -l`
        echo $(date) " # of DB connections:" $conn >> monitor.out

        top -b -n 1 -p  10017  |grep java | awk '{print "CPU Utilization: " $9}' >> monitor.out
        top -b -n 1 -p  10017  |grep java | awk '{print "Virtual Mem: " $5}' >> monitor.out
        top -b -n 1 -p  10017  |grep java | awk '{print "Res Mem: " $6}' >> monitor.out
        top -b -n 1 -p  10017  |grep java | awk '{print "Shr Mem: " $7}' >> monitor.out
        sleep 30s
done

