FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV JENKINS_HOME=/var/jenkins_home

RUN apt-get update && \
    apt-get install -y openjdk-17-jdk docker.io curl git wget gnupg unzip && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -d ${JENKINS_HOME} -s /bin/bash jenkins

RUN mkdir -p /opt/jenkins && \
    wget -q -O /opt/jenkins/jenkins.war https://get.jenkins.io/war-stable/latest/jenkins.war

EXPOSE 8080
WORKDIR ${JENKINS_HOME}
CMD ["java", "-jar", "/opt/jenkins/jenkins.war"]
