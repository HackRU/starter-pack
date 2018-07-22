XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

#build the image if we havn't already...
(docker image ls | grep testing-x) || (docker build -t testing-x .)

docker run -it\
    --volume=$XSOCK:$XSOCK:rw \
    --volume=$XAUTH:$XAUTH:rw \
    --env="XAUTHORITY=${XAUTH}" \
    --env="DISPLAY" \
    -u"archie" \
    testing-x xterm
