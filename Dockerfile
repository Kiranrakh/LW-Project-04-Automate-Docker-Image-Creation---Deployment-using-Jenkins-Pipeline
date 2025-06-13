FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV JENKINS_HOME=/var/jenkins_home

# Install Java 17, Docker CLI, and essential tools
RUN apt-get update && \
    apt-get install -y \
    openjdk-17-jdk \
    docker.io \
    curl \
    git \
    wget \
    gnupg \
    unzip && \
    rm -rf /var/lib/apt/lists/*

# Create Jenkins user and Jenkins home directory
RUN useradd -m -d ${JENKINS_HOME} -s /bin/bash jenkins

# Download latest Jenkins WAR file
RUN mkdir -p /opt/jenkins && \
    wget -q -O /opt/jenkins/jenkins.war https://get.jenkins.io/war-stable/latest/jenkins.war

# Expose Jenkins default port
EXPOSE 8080

# Set working directory to Jenkins home (optional but clean)
WORKDIR ${JENKINS_HOME}

# Run Jenkins as root (to ensure docker commands work)
CMD ["java", "-jar", "/opt/jenkins/jenkins.war"]
