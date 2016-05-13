FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

#ADD Repos
RUN apt-get update 
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN add-apt-repository ppa:chris-lea/redis-server
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
RUN apt-get update
#INSTALL PHP7, Redis server 3.0, tools
RUN apt-get install -y php7.0-cli php7.0-dom php7.0-zip redis-server git curl build-essential libtool automake php7.0-dev
#INSTALL LIBUV
RUN cd /tmp/ && mkdir libuv && (curl -L https://github.com/libuv/libuv/archive/v1.6.1.tar.gz | tar xzf -) && cd libuv-1.6.1 && ./autogen.sh && ./configure --prefix=$(readlink -f `pwd`/../libuv) && make && make install
RUN cd /tmp/ && git clone https://github.com/bwoebi/php-uv && cd php-uv && phpize && ./configure --with-uv=$(readlink -f `pwd`/../libuv) && make install
#INSTALL COMPOSER
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
RUN sed -i "s/^daemonize yes/daemonize no/" /etc/redis/redis.conf
VOLUME /srv/project
EXPOSE 1337
CMD ["redis-server","/etc/redis/redis.conf"]