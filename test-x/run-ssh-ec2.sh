#USAGE: ./thingy pem ssh-url port
#port is the port to expose, be sure the AWS is OK with it...

echo "Starting docker on the remote..."
ssh -i $1 $2 "sh ~/HackRU-Starter-Pack/test-x/run-ssh.sh $3"

echo "Starting desktop session..."
DESKTOP_SESS_NUM=10
IP_ADDR= $(echo $2 | cut -d@ -f2)
ssh docker@$IPADDR -p $3 "sh -c './docker-desktop -s 800x600 -d $DESKTOP_SESS_NUM > /dev/null 2>&1 &'"

echo "Attaching xpra"
xpra --ssh="ssh -p $3" attach ssh:docker@$IP_ADDR:$DESKTOP_SESS_NUM
