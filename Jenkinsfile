pipeline {
    agent any
    
    tools {
        maven 'mvn-3-5-4'
    }
    
    environment {
        IMAGE_TAG = "v${BUILD_NUMBER}"
        DOCKER_IMAGE = "ahmedshalaby88/task2_cicd"
        DOCKER_USERNAME = "ahmedshalaby88"  // اكتب username هنا مباشرة
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo "📥 Checking out source code..."
                git branch: 'main',
                    url: 'https://github.com/ahmedshalaby88/Java_App.git',
                    credentialsId: 'github'
            }
        }
        
        stage('Build & Test') {
            steps {
                echo "🔨 Building and testing application..."
                sh "mvn clean package -DskipTests"
                sh "mvn test"
                sh "ls -la target/*.jar"
            }
        }
        
        stage('Archive Artifact') {
            steps {
                echo "📦 Archiving artifacts..."
                archiveArtifacts artifacts: 'target/*.jar'
            }
        }
        
        stage('Docker Build & Push') {
            steps {
                echo "🐳 Building and pushing Docker image..."
                script {
                    try {
                        // Create Dockerfile if missing
                        if (!fileExists('Dockerfile')) {
                            writeFile file: 'Dockerfile', text: '''FROM openjdk:11-jre-slim
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]'''
                            echo "✅ Dockerfile created"
                        }
                        
                        // Method for Secret Text credential
                        withCredentials([string(
                            credentialsId: 'docker',
                            variable: 'DOCKER_TOKEN'
                        )]) {
                            // Login using token as password
                            sh "echo \$DOCKER_TOKEN | docker login -u ${DOCKER_USERNAME} --password-stdin"
                            
                            // Build Docker image
                            sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
                            sh "docker tag ${DOCKER_IMAGE}:${IMAGE_TAG} ${DOCKER_IMAGE}:latest"
                            
                            // Push to Docker Hub
                            sh "docker push ${DOCKER_IMAGE}:${IMAGE_TAG}"
                            sh "docker push ${DOCKER_IMAGE}:latest"
                            
                            echo "✅ Docker image pushed successfully!"
                            echo "🔗 Image: ${DOCKER_IMAGE}:${IMAGE_TAG}"
                        }
                        
                    } catch (Exception e) {
                        echo "❌ Docker operation failed: ${e.getMessage()}"
                        
                        // Debug information
                        echo "🔍 Debug Information:"
                        sh "whoami"
                        sh "docker --version || echo 'Docker not found'"
                        sh "docker info || echo 'Docker daemon not running'"
                        
                        throw e
                    }
                }
            }
        }
    }
    
    post {
        always {
            script {
                // Logout from Docker (security)
                sh "docker logout || true"
            }
            cleanWs()
        }
        success {
            echo "✅ Pipeline completed successfully!"
            echo "🐳 Docker image: ${DOCKER_IMAGE}:${IMAGE_TAG}"
            echo "🔗 Available at: https://hub.docker.com/r/ahmedshalaby88/task2_cicd"
        }
        failure {
            echo "❌ Pipeline failed!"
            echo "🔍 Check Docker Hub access token and credentials"
        }
    }
}
