#!/bin/bash

if [ ! -f /usr/bin/git ]
then
	sudo yum -y install git
fi

if [ ! -f /usr/bin/java ]
then
	echo "Installing Java"
	sudo yum -y install java
fi

JAVAVER=`java -version 2>&1 /dev/stdout | awk '/version/ {print $3}'`

if [[ $JAVAVER =~ .*1\.8.* ]] 
then
	echo "Java version is sufficient"
else
	echo "Java needs to be upgraded"
	sudo yum -y update java

fi

if [ ! -d /opt/jenkins ]
then
	mkdir /opt/jenkins
fi

cd /opt/jenkins

git clone https://github.com/bgautrea/jenkinssetup


user_exists=$(id -u jenkins > /dev/null 2>&1; echo $?)
if [ $user_exists == 1 ]
then
	/opt/jenkins/jenkinssetup/addUser.sh
fi

if [ ! -f /etc/init.d/jenkins ]
then
	cp jenkinssetup/jenkins /etc/init.d
fi

if [ ! -f /etc/systemd/system/multi-user.target.wants/jenkins.service ]
then
       cp jenkinssetup/jenkins.service /etc/systemd/system/multi-user.target.wants
fi

systemctl daemon-reload

if [ ! -f /opt/jenkins/jenkins.war ]
then
	wget -nc http://mirrors.jenkins.io/war-stable/latest/jenkins.war
fi


