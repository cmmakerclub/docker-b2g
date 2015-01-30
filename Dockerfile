FROM ubuntu:12.04

MAINTAINER Nat "nat.wrw@gmail.com"

RUN echo "deb http://mirror1.ku.ac.th/ubuntu/ precise main restricted universe" > /etc/apt/sources.list
RUN echo "deb http://mirror.kku.ac.th/ubuntu/ precise main restricted universe" >> /etc/apt/sources.list
RUN echo "deb http://mirror1.ku.ac.th/ubuntu/ precise-updates main restricted universe" >> /etc/apt/sources.list
RUN echo "deb http://mirror1.ku.ac.th/ubuntu/ precise-security main restricted universe" >> /etc/apt/sources.list
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade  -y
RUN DEBIAN_FRONTEND=noninteractive apt-get update

RUN apt-get install -y vim bash-completion build-essential openssh-server sudo unzip gawk
RUN apt-get install -y autoconf2.13 bison bzip2 ccache curl flex gawk gcc g++ g++-multilib git ia32-libs lib32ncurses5-dev lib32z1-dev libgl1-mesa-dev libx11-dev make zip

RUN useradd -d /home/nat -m -s /bin/bash nat
RUN echo "nat ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/nat


RUN chmod 0440 /etc/sudoers.d/nat

# add ssh server
RUN mkdir /var/run/sshd
RUN echo 'nat:nat' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config


# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

