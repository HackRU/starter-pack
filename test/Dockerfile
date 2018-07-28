FROM osrf/ros:indigo-desktop-full

ENV USERNAME archie
RUN useradd -m $USERNAME && \
    echo "$USERNAME:$USERNAME" | chpasswd && \
    usermod --shell /bin/bash $USERNAME && \
    usermod -aG sudo $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME && \
    usermod --uid 1000 $USERNAME && \
    usermod --gid 1000 $USERNAME

USER $USERNAME
FROM ubuntu:latest

# install dependencies
RUN apt update
RUN apt install -y apt-transport-https
RUN apt install -y curl
RUN apt install -y git
RUN curl -sL https://deb.nodesource.com/setup_8.x
RUN apt install -y build-essential nodejs npm

# get OS.js
RUN git clone https://github.com/os-js/OS.js.git && \
    cd OS.js

# build and project OS.js, exposes to port 8000
WORKDIR OS.js/
RUN npm install && \
    node osjs build

RUN npm install -g supervisor
RUN npm install sqlite3 mysql
CMD ["bash", "bin/docker_start.sh"]
EXPOSE 8000
