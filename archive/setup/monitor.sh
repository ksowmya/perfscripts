while :
do
        echo $(date) >> monitor.out
        conn=`netstat -ant | grep 3306 | grep 10.223.75.135| grep ESTABLISHED |   wc -l`
        echo $(date) " # of DB connections:" $conn >> monitor.out
        conn=`netstat -ant | grep 3306 | grep 10.223.41.4| grep ESTABLISHED | wc   -l`
        echo $(date) " # of simulator DB connections:" $conn >> monitor.out
	conn=`netstat -ant | grep 9090 | grep ESTABLISHED | wc -l`
        echo $(date) " # of 9090 Established connections:" $conn >> monitor.out
        conn=`netstat -ant | grep 9090 | grep CLOSE_WAIT | wc -l`
        echo $(date) " # of 9090  CLOSE_WAIT connections:" $conn >> monitor.out
        conn=`netstat -ant | grep 9090 | grep TIME_WAIT | wc -l`
        echo $(date) " # of 9090  TIME_WAIT connections:" $conn >> monitor.out
        conn=`netstat -ant | grep 9090 | wc -l`
        echo $(date) " # of 9090 connections:" $conn >> monitor.out

        top -b -n 1 -p 30170 |grep load | awk '{print "Load Avg: " $12 $13 $14}' >> monitor.out
        top -b -n 1 -p 30170 |grep cloud| awk '{print "CPU Utilization: " $9}' >> monitor.out
        sleep 30s
done

