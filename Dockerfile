FROM ubuntu
HEALTHCHECK --start-period=5m CMD wget --quiet --tries=1 --no-check-certificate http://127.0.0.1:8088 || exit 1
MAINTAINER Ronald den Otter <ronald.den.otter@gmail.com>

COPY entrypoint.sh /entrypoint.sh

# install omada controller (instructions taken from install.sh); then create a user & group and set the appropriate file system permissions
RUN \
  echo "**** Install Dependencies ****" &&\
  apt-get update &&\
  DEBIAN_FRONTEND="noninteractive" apt-get install -y gosu net-tools tzdata wget curl  libboost-chrono1.65.1 libboost-filesystem1.65.1 libboost-program-options1.65.1 libboost-regex1.65.1 libboost-system1.65.1 libboost-thread1.65.1 libicu60 libpcrecpp0v5 libsnappy1v5 libstemmer0d libyaml-cpp0.5v5 openjdk-8-jdk-headless --no-install-recommends &&\
  cd /tmp/ &&\
  wget ftp://ftp.rent-a-guru.de/private/omada-sdn-controller_4.1.5-1_all.deb &&\
  wget --no-check-certificate https://github.com/ddcc/mongodb/releases/download/v3.2.22-2/mongodb-clients_3.2.22-2_armhf.deb &&\
  wget --no-check-certificate https://github.com/ddcc/mongodb/releases/download/v3.2.22-2/mongodb-server_3.2.22-2_all.deb &&\
  wget --no-check-certificate https://github.com/ddcc/mongodb/releases/download/v3.2.22-2/mongodb-server-core_3.2.22-2_armhf.deb &&\
  wget --no-check-certificate https://github.com/ddcc/mongodb/releases/download/v3.2.22-2/mongodb_3.2.22-2_armhf.deb &&\
  echo "**** Setup omada User Account ****" &&\
  groupadd -g 508 omadad &&\
  useradd -u 508 -g 508 -d /opt/tplink/OmadaController omadad &&\
  cd /tmp/ &&\
  echo exit 101 > /usr/sbin/policy-rc.d &&\
  dpkg -i mongodb-server-core_3.2.22-2_armhf.deb mongodb-server_3.2.22-2_all.deb mongodb-clients_3.2.22-2_armhf.deb mongodb_3.2.22-2_armhf.deb &&\
  rm -f /usr/sbin/policy-rc.d && rm -f mongodb-server-core_3.2.22-2_armhf.deb mongodb-server_3.2.22-2_all.deb mongodb-clients_3.2.22-2_armhf.deb mongodb_3.2.22-2_armhf.deb &&\
  cd /tmp/ &&\
  echo exit 101 > /usr/sbin/policy-rc.d &&\
  chmod +x /usr/sbin/policy-rc.d &&\
  echo "**** Install Omada Controller ****" &&\
  DEBIAN_FRONTEND="noninteractive" dpkg -i /tmp/omada-sdn-controller_4.1.5-1_all.deb &&\
  rm -f /usr/sbin/policy-rc.d && rm -f /tmp/omada-sdn-controller_4.1.5-1_all.deb

COPY omadad /etc/default/omadad

WORKDIR /opt/tplink/OmadaController
EXPOSE 8088 8043 27001/udp 27002 29810/udp 29811 29812 29813
VOLUME ["/opt/tplink/OmadaController/data","/opt/tplink/OmadaController/work","/opt/tplink/OmadaController/logs"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/lib/jvm/java-8-openjdk-armhf/jre/bin/java","-server","-Xms128m","-Xmx512m","-XX:MaxHeapFreeRatio=60","-XX:MinHeapFreeRatio=30","-XX:+HeapDumpOnOutOfMemoryError","-XX:-UsePerfData","-Deap.home=/opt/tplink/OmadaController","-cp","/opt/tplink/OmadaController/lib/*:","com.tplink.omada.start.OmadaLinuxMain"]

#  export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-armhf/jre
#  /usr/lib/jvm/java-8-openjdk-armhf/jre/bin/java -server -Xms128m -Xmx512m -XX:MaxHeapFreeRatio=60 -XX:MinHeapFreeRatio=30 -XX:+HeapDumpOnOutOfMemoryError -XX:-UsePerfData -Deap.home=/opt/tplink/OmadaController -cp /opt/tplink/OmadaController/lib/*:  com.tplink.omada.start.OmadaLinuxMain
