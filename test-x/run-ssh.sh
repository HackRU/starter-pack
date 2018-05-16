
#build image if not there
(docker image ls | grep ssh-test) || (docker build -t ssh-test git://github.com/rogaha/docker-desktop.git)
#run image, putting first argument as port. Empty string is OK: docker will just pick a port
CONTAINER_ID=$(docker run -d -p $1:22 ssh-test)
echo "Credentials: $(docker logs $CONTAINER_ID | sed -n 1p)"
PORT=$(docker port $CONTAINER_ID 22)
echo "External port: $PORT"

echo "Starting session..."
IP_ADDR = "$(hostname | sed -e 's/ip/ec2/').us-west-2.compute.amazonaws.com"
echo $IP_ADDR
DESKTOP_SESS_NUM=10
ssh docker@$IPADDR -p $PORT "sh -c './docker-desktop -s 800x600 -d $DESKTOP_SESS_NUM > /dev/null 2>&1 &'"
echo "run:\nxpra --ssh=\"ssh -p $PORT\" attach ssh:docker@$IP_ADDR:$DESKTOP_SESS_NUM"
