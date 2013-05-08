grep "cidrs=$1" $2 | grep "updated iptables" > $3.txt
count=`cat $3.txt | wc -l`
echo $count
a=`head -1 $3.txt | awk '{print $1 " " $2}'`
echo $a
b=`tail -1 $3.txt | awk '{print $1 " " $2}'`
echo $b

