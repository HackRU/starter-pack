FROM ubuntu:16.04

RUN apt update && apt install -y curl \
    && curl https://winswitch.org/gpg.asc | apt-key add - \
    && echo "deb http://winswitch.org/ xenial main" > /etc/apt/sources.list.d/winswitch.list

RUN apt  update && DEBIAN_FRONTEND=noninteractive apt install -y openssh-server \
    x11-apps xterm language-pack-en-base \
    xserver-xephyr i3 xpra
RUN apt install websockify
CMD  xpra start --bind-tcp=0.0.0.0:14500 --html=on --start=xterm && tail -f /dev/null
EXPOSE 14500
