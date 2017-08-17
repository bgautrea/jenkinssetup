#!/bin/bash
JENKINS_WAR=/usr/local/jenkins/jenkins.war
JENKINS_LOG=/home/jenkins/jenkins.log
JAVA=/usr/local/java/bin/java
nohup nice $JAVA -jar $JENKINS_WAR > $JENKINS_LOG 2>&1 &
Raw

