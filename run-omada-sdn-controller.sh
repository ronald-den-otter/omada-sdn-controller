#!/bin/bash
version=latest
#version=4.1.5-1

# migrate to new version with:
# mkdir /opt/tplink/$version
# cd /opt/tplink/$oldversion
# tar -czvSf - OmadaController | tar -xzvSf - -C /opt/tplink/$version
# if its running ok you can safely remove /opt/tplink/$oldversion

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
omadadata="/opt/tplink/$version/OmadaController/data"
omadawork="/opt/tplink/$version/OmadaController/work"
omadalogs="/opt/tplink/$version/OmadaController/logs"

mkdir -p $omadadata
mkdir -p $omadawork
mkdir -p $omadalogs

# small files is not working (yet)
docker run -d \
        --name omada-controller \
        --network host \
        --memory 512m \
        --rm \
        -e TZ=Europe/Amsterdam \
        -e SMALL_FILES=false \
        -p 8088:8088   -p 8043:8043   -p 27001:27001/udp   -p 27002:27002   -p 29810:29810/udp   -p 29811:29811   -p 29812:29812   -p 29813:29813  \
        -v $omadadata:/opt/tplink/OmadaController/data   -v $omadawork:/opt/tplink/OmadaController/work   -v $omadalogs:/opt/tplink/OmadaController/logs \
        ronaldo1965/omada-sdn-controller:$version
