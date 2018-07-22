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
RUN apt install build-essential nodejs npm 

# get OS.js
RUN git clone https://github.com/os-js/OS.js.git && \
    cd OS.js

# build and project OS.js, exposes to port 8000
RUN npm install && \
    node osjs build && \
    node osjs run

