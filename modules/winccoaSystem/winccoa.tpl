#!/bin/bash
sudo yum update -y
#install docker
sudo amazon-linux-extras install docker -y
#start docker
sudo service docker start
#install git
sudo yum install git -y
sudo mkdir /opt/winccoa/
cd /opt/winccoa/
#install java
sudo yum install java -y
#download wincc oa 3.15 base
sudo wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=199hz9z1-Vhbc_FziDi0Gb7Ulmie5zTNZ' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=199hz9z1-Vhbc_FziDi0Gb7Ulmie5zTNZ" -O WinCC_OA_3.15-base-rhel-0-37.x86_64.rpm && rm -rf /tmp/cookies.txt
#install wincc oa 3.15 base
sudo yum -y install /opt/winccoa/WinCC_OA_3.15-base-rhel-0-37.x86_64.rpm
#download wincc oa 3.15 sql
sudo wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=19Jr-cEEyXFTmHqxEl-FZAARjMUEedRzx' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=19Jr-cEEyXFTmHqxEl-FZAARjMUEedRzx" -O WinCC_OA_3.15-sqldrivers-rhel-0-37.x86_64.rpm && rm -rf /tmp/cookies.txt
#install wincc oa 3.15 sql
sudo yum -y install /opt/winccoa/WinCC_OA_3.15-sqldrivers-rhel-0-37.x86_64.rpm
echo ${connectToOpcUaServers} >> servers.txt
export OPCUA_Servers=${connectToOpcUaServers}
echo ${dbHost} >> dbhost.txt
export DB_Host=${dbHost}
echo ${dbUser} >> dbUser.txt
export DB_User=${dbUser}
echo ${dbPassword} >> dbPassword.txt
export DB_Password=${dbPassword}
#clone git repo
sudo git clone https://github.com/2110781006/TMCS-PT-Monitoring.git
cd TMCS-PT-Monitoring/modules/winccoaSystem/OPCUA_Client
#wincc database unzip
sudo unzip -ou db.zip
#wincc oa  starten
sudo -E /opt/WinCC_OA/3.15/bin/WCCILpmon -autofreg -config /opt/winccoa/TMCS-PT-Monitoring/modules/winccoaSystem/OPCUA_Client/config/config

##sudo docker run -p 24224:24224 -p 24224:24224/udp -u fluent -v /opt/myy:/fluentd/etc fluentd
