# omada-sdn-controller on Raspberry PI
Omada SDN Controller on Raspberry PI  
Tested on:  
RPI3+ with host OS Raspian Buster 10 32-bits, ARMv7 Processor rev 4 (v7l) (build platform)  
BPI M2-Berry with host OS Raspian Stretch 9.12 32-bits,  ARMv7 Processor rev 5 (v7l) (run platform)  

Specs in image:  
Ubuntu 18.04 on ARMHF  
omada-sdn-controller_4.2.4-1_all.deb (Thanks R1D2 https://community.tp-link.com/en/business/forum/topic/217298?replyId=465264&utm_source=Subscription&utm_medium=email)  
mongodb 3.2.22-2 for ARMHF           (Thanks Dominic Chen https://github.com/ddcc/mongodb/releases)  
openjdk-8-jdk-headless               (Although there are still doubts, didn't find any problems)  

See also:
https://hub.docker.com/repository/docker/ronaldo1965/omada-sdn-controller

Docker:
docker pull ronaldo1965/omada-sdn-controller

