
docker build -t ssh-test git://github.com/rogaha/docker-desktop.git
CONTAINER_ID=$(docker run -d -P ssh-test)
echo "Credentials: $(docker logs $CONTAINER_ID | sed -n 1p)"
PORT=$(docker port $CONTAINER_ID 22)
echo "External port: $PORT"

echo "Starting session..."
IP_ADDR = $(ifconfig | grep "inet addr:" | cut -f 1 | cut -d: -f 2)
echo $IP_ADDR
DESKTOP_SESS_NUM=10
ssh docker@$IPADDR -p $PORT "sh -c './docker-desktop -s 800x600 -d $DESKTOP_SESS_NUM > /dev/null 2>&1 &'"
