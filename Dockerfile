FROM ubuntu:22.04

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update \
  && apt install -y wget curl vim lsb-release python3-pip iputils-ping build-essential gcc-multilib g++-multilib \
  && pip3 install python-gnupg 

# Install latest Mysql
# RUN apt-get -y install mysql-server

# Add MySQL 5.7 repository
RUN wget https://dev.mysql.com/get/mysql-apt-config_0.8.12-1_all.deb

RUN { \
  echo 'mysql-apt-config mysql-apt-config/repo-codename select bionic'; \
  echo 'mysql-apt-config mysql-apt-config/repo-distro select ubuntu'; \
  echo 'mysql-apt-config mysql-apt-config/repo-url string http://repo.mysql.com/apt/'; \
  echo 'mysql-apt-config mysql-apt-config/select-preview select '; \
  echo 'mysql-apt-config mysql-apt-config/select-product select Ok'; \
  echo 'mysql-apt-config mysql-apt-config/select-server select mysql-5.7'; \
  echo 'mysql-apt-config mysql-apt-config/select-tools select '; \
  echo 'mysql-apt-config mysql-apt-config/unsupported-platform select Ok'; \
  echo 'mysql-apt-config mysql-apt-config/repo-url string http://repo.mysql.com/apt/'; \
  echo 'mysql-apt-config mysql-apt-config/select-preview select '; \
  echo 'mysql-apt-config mysql-apt-config/select-product select Ok'; \ 
  } | debconf-set-selections

RUN dpkg -i mysql-apt-config_0.8.12-1_all.deb

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29 \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B7B3B788A8D3785C \
  && apt update \
  && apt-cache policy mysql-server 

# Install Mysql 5.7
RUN apt install -y -f mysql-client=5.7* mysql-community-server=5.7* mysql-server=5.7*


# enable login using above creds
RUN usermod -d /var/lib/mysql/ mysql \
  && MYSQLD_OPTS="--skip-grant-tables" service mysql start \
  && mysql -u root --execute="drop user root@localhost; create user 'root'@'%' identified by ''; grant all privileges on *.* to 'root'@'%' with grant option;" \
  && mysql -u root --execute="FLUSH PRIVILEGES" \
  && service mysql stop 

# Install MongoDB
RUN curl -O http://downloads.mongodb.org/linux/mongodb-linux-x86_64-3.2.22.tgz \
  && tar -zxvf mongodb-linux-x86_64-3.2.22.tgz \
  && mkdir -p /data/db \
  && rm -rf mongodb-linux-x86_64-3.2.22.tgz

# Application mounting & permissions
COPY syscall_node/ /syscall_node/
COPY startUpScript.sh /syscall_node/
COPY syscall_node/attack.sh /

WORKDIR /syscall_node/

ENV NVM_DIR /root/.nvm
# Install NVM(Node)
RUN curl -LsS https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash \
  && . $NVM_DIR/nvm.sh \
  && apt update \
  && apt-get install -y git 

RUN chmod 777 /syscall_node/startUpScript.sh
RUN chmod 777 /syscall_node/attack.sh

ENV NEW_RELIC_SECURITY_CONFIG_PATH=""
ENV NR_OPTS=""
ENV APM_BRANCH=""
ENV CSEC_BRANCH=""
ENV NODE_VERSION=""
ENV APM_VERSION="latest"

CMD ["/bin/bash","-c","/syscall_node/startUpScript.sh && tail -f /dev/null"]
