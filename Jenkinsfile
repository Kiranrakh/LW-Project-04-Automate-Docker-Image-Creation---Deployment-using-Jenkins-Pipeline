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
    }

    post {
        success {
            echo "✅ Build and push successful!"
        }
        failure {
            echo "❌ Build or push failed. Check logs."
        }
    }
}
