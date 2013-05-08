host=$1
command=$2
args=$3
apiKey="xvTAbRBxcYxzhyMABe-ALNXVrtUmTyUVfbr_nOJ4Y62u-tUAYO7kfDnXqp5je-2Hsxva3sqdB7_x_VbjHjmBSA"
secretKey="HI8jTmWOQPuq1feqnda68dQVit8reGT_G7MdW3gFbKVQvMhXk20MMrcwc7zRkW5WaXxSjPSs2dO7YfXg-rLN5g"
apiStr=`python ./sign_api.py ${command} ${args} $apiKey $secretKey`
apiStr="GET http://$host/client/api?command=$command&${args}&apiKey=${apiKey}&signature=${apiStr} HTTP/1.0\n\n"
query_out=$(echo -e $apiStr | nc -v -w 300 $host 8080)
echo $query_out
