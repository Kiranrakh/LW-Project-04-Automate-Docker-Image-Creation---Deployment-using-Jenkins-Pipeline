FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk curl gnupg2 git docker.io

# Add Jenkins repo & install Jenkins
RUN curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null && \
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null && \
    apt-get update && \
    apt-get install -y jenkins

# Expose port & start Jenkins
EXPOSE 8080
CMD ["bash", "-c", "service jenkins start && tail -f /var/log/jenkins/jenkins.log"]
