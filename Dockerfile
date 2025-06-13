FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV JENKINS_HOME /var/jenkins_home

# Install Java 17 and other essentials
RUN apt-get update && \
    apt-get install -y \
    openjdk-17-jdk \
    curl \
    git \
    wget \
    gnupg \
    unzip && \
    rm -rf /var/lib/apt/lists/*

# Create Jenkins user and home
RUN useradd -m -d $JENKINS_HOME -s /bin/bash jenkins

# Download Jenkins WAR file (latest LTS)
RUN mkdir -p /opt/jenkins && \
    wget -q -O /opt/jenkins/jenkins.war https://get.jenkins.io/war-stable/latest/jenkins.war

# Expose Jenkins default port
EXPOSE 8080

# Set permissions and switch to Jenkins user
USER jenkins
WORKDIR /var/jenkins_home

# Run Jenkins
CMD ["java", "-jar", "/opt/jenkins/jenkins.war"]
