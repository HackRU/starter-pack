
#build image if not there
(docker image ls | grep ssh-test) || (docker build -t ssh-test git://github.com/rogaha/docker-desktop.git)
#run image, putting first argument as port. Empty string is OK: docker will just pick a port
CONTAINER_ID=$(docker run -d -p $1:22 ssh-test)
#we need creds... client-side sshes will require it.
echo "Credentials: $(docker logs $CONTAINER_ID | sed -n 1p)"
PORT=$(docker port $CONTAINER_ID 22)
#echo port just in case the client didn't set it...
echo "External port: $PORT"
