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

echo "Pulling the latest jenkins setup from GitHub"

git clone https://github.com/bgautrea/jenkinssetup


user_exists=$(id -u jenkins > /dev/null 2>&1; echo $?)
if [ $user_exists == 1 ]
then
	/opt/jenkins/jenkinssetup/addUser.sh
else
	echo "THe jenkins user already exists"
fi

if [ ! -f /etc/init.d/jenkins ]
then
	cp /opt/jenkins/jenkinssetup/jenkins /etc/init.d
else
	echo "Jenkins startup script already exists"
fi


if [ ! -f /etc/firewalld/services/jenkins.xml ]
then
	cp /opt/jenkins/jenkinssetup/jenkins.xml /etc/firewalld/services
	firewall-cmd --reload
	firewall-cmd --zone=public --permanent --add-service=jenkins
else
	echo "The firewall service is already configured for jenkins on port 8000"
fi


if [ ! -f /opt/jenkins/jenkins.war ]
then
	wget -nc http://mirrors.jenkins.io/war-stable/latest/jenkins.war
else
	echo "Jenkins already exists in /opt/jenkins"
fi


if [ ! -f /etc/systemd/system/multi-user.target.wants/jenkins.service ]
then
	cp /opt/jenkins/jenkinssetup/jenkins.service /etc/systemd/system/multi-user.target.wants
	systemctl daemon-reload
else
	echo "It looks like the Jenkins startup service already exists"
fi

systemctl start jenkins.service
