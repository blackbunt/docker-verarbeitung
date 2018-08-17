FROM phusion/baseimage
MAINTAINER rix1337

# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Configure user nobody to match unRAID's settings
 RUN \
 usermod -u 99 nobody && \
 usermod -g 100 nobody && \
 usermod -d /home nobody && \
 chown -R nobody:users /home

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Move Files
VOLUME ["/config", "/downloads", "/plex"]
ADD root/ /
RUN chmod +x /etc/my_init.d/*.sh

# Install Java/MKVtoolnix/Mediainfo/rsync
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y wget mkvtoolnix oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer && \
  chmod -R +x /config && \
  chown -R nobody:users /config
  
RUN curl -fsSL https://raw.githubusercontent.com/filebot/plugins/master/gpg/maintainer.pub | apt-key add \
 && echo "deb [arch=amd64] https://get.filebot.net/deb/ stable main" > /etc/apt/sources.list.d/filebot.list \
 && apt-get update \
 && apt-get install -y filebot mediainfo libchromaprint-tools curl file inotify-tools \
 && rm -rvf /var/lib/apt/lists/*
