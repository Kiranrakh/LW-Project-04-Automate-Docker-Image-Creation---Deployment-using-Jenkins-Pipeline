# 🚀 Automate Docker Image Creation & Deployment using Jenkins Pipeline

This project demonstrates a complete CI/CD workflow using **Jenkins**, **Docker**, and a **local Docker Registry**, deployed on an **AWS EC2 Ubuntu instance**.

---

## 📌 PHASE 1: Launch EC2 & Install Docker

### Step 1: Launch EC2
- **OS**: Ubuntu 22.04
- **Instance Type**: t2.medium or above
- **Security Group**: Allow ports 22, 8080, 5000, 8081 (for Jenkins, Registry, Web App)

### Step 2: Connect via SSH
```bash
ssh -i your-key.pem ubuntu@<EC2-PUBLIC-IP>
````

### Step 3: Install Docker

```bash
sudo apt update -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
```

### Step 4: Add Docker Permissions

```bash
sudo usermod -aG docker $USER
newgrp docker
```

---

## 📌 PHASE 2: Create Jenkins Dockerfile

Create a `Dockerfile`:

```Dockerfile
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
```

### Build the Jenkins Docker Image

```bash
docker build -t jenkins-image .
```

---

## 📌 PHASE 3: Run Jenkins Container

```bash
docker run -d \
  --name jenkins \
  --privileged \
  --user root \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v jenkins_home:/var/jenkins_home \
  -p 8080:8080 \
  jenkins-image
```

### Get Initial Jenkins Password

```bash
docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Visit Jenkins:
👉 `http://<EC2-PUBLIC-IP>:8080`

---

## 📌 PHASE 4: Install Jenkins Plugins

Install plugins:

* Git
* Docker Pipeline
* Pipeline
* Docker Commons
* Docker API
* GitHub Integration

---

## 📌 PHASE 5: Setup Local Docker Registry

```bash
docker run -d -p 5000:5000 --name registry registry:2
```

Verify:
👉 `http://<EC2-PUBLIC-IP>:5000/v2/_catalog`

---

## 📌 PHASE 6: Jenkins Pipeline Job

### Create New Item → Pipeline → `docker-build-pipeline`

**Pipeline Definition**: Pipeline script from SCM
**SCM**: Git
**Repo URL**:

```
https://github.com/Kiranrakh/LW-Project-04-Automate-Docker-Image-Creation---Deployment-using-Jenkins-Pipeline.git
```

**Jenkinsfile**:

```groovy
pipeline {
    agent any
    environment {
        IMAGE_NAME = "myapp"
        REGISTRY = "localhost:5000"
        TAG = "v1"
    }
    stages {
        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image..."
                sh "docker build -t ${REGISTRY}/${IMAGE_NAME}:${TAG} ./app"
            }
        }
        stage('Push to Local Registry') {
            steps {
                echo "📤 Pushing image to local registry..."
                sh "docker push ${REGISTRY}/${IMAGE_NAME}:${TAG}"
            }
        }
        stage('Run Docker Container') {
            steps {
                echo "🚀 Running the Docker container..."
                sh "docker run -d -p 8081:80 ${REGISTRY}/${IMAGE_NAME}:${TAG}"
            }
        }
    }
    post {
        success {
            echo "✅ Pipeline completed successfully."
        }
        failure {
            echo "❌ Pipeline failed. Check logs."
        }
    }
}
```

---

## 📌 PHASE 7: Trigger the Pipeline Job

* Click **Build Now**
* Wait for stages: Clone → Build → Push → Run

---

## ✅ Final Step: Access Your Web App

Visit:
👉 `http://<EC2-PUBLIC-IP>:8081`
(The app should be running!)

---

## 🧹 Cleanup (if needed)

```bash
docker stop jenkins registry
docker rm jenkins registry
docker volume rm jenkins_home
docker rmi jenkins-image localhost:5000/myapp:v1
```

---

## 🙌 Credits

Project by **Kiran Rakh**
LinuxWorld Internship | Mentored by **Vimal Daga Sir**

```


