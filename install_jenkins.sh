#!/bin/sh
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
#!Install Jenkins
sudo yum install java-1.8* -y
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo 
sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key 
sudo yum install jenkins -y
sudo service jenkins start
sudo chkconfig --add jenkins
sudo yum install git -y

# install maven
if [[ ! -d /opt/apache-maven-3.1.1 ]];then
  cd /usr/src
    sudo wget http://mirror.olnevhost.net/pub/apache/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz
    sudo tar -xvzf apache-maven-3.1.1-bin.tar.gz
    sudo mv apache-maven-3.1.1 /opt/
  cd -
fi



