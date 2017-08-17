#! /bin/bash

groupadd jenkins
useradd -g jenkins jenkins
 
mkdir /home/jenkins

chown -R jenkins /home/jenkins
