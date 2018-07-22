#USAGE: ./thingy pem ssh-url port
#port is the port to expose, be sure the AWS is OK with it...
#Example:
# sh run-ssh-ec2.sh ../../ec2/docker-testing.pem ubuntu@ec2-54-190-23-86.us-west-2.compute.amazonaws.com 5000

echo "Starting docker on the remote..."
ssh -i $1 $2 "sudo sh ~/HackRU-Starter-Pack/test-x/run-ssh.sh $3"

echo "Starting desktop session..."
DESKTOP_SESS_NUM=10
ssh docker@$(echo "$2" | cut -d@ -f2) -p $3 "sh -c './docker-desktop -s 800x600 -d $DESKTOP_SESS_NUM > /dev/null 2>&1 &'"

echo "Attaching xpra"
xpra --ssh="ssh -p $3" attach ssh:docker@$(echo "$2" | cut -d@ -f2):$DESKTOP_SESS_NUM
