pipeline {
    agent any

    environment {
        IMAGE_NAME = "myapp"
        REGISTRY = "localhost:5000"
        TAG = "v1"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git 'https://github.com/Kiranrakh/LW-Project-04-Automate-Docker-Image-Creation---Deployment-using-Jenkins-Pipeline.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${REGISTRY}/${IMAGE_NAME}:${TAG} ./app"
            }
        }

        stage('Push to Local Registry') {
            steps {
                sh "docker push ${REGISTRY}/${IMAGE_NAME}:${TAG}"
            }
        }
    }
}
