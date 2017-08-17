#!/bin/bash
JENKINS_WAR=/opt/jenkins/jenkins.war
JENKINS_OPTS=" --httpPort=8000 "
JENKINS_LOG=/home/jenkins/jenkins.log
JAVA=/usr/bin/java
nohup nice $JAVA -jar $JENKINS_WAR $JENKINS_OPTS > $JENKINS_LOG 2>&1 &
