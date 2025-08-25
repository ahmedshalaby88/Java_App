pipeline {
    agent any
    
    tools {
        maven 'mvn-3-5-4'
    }
    
    environment {
        IMAGE_TAG = "v${BUILD_NUMBER}"
        DOCKER_IMAGE = "ahmedshalaby88/task2_cicd"
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
                    // Create Dockerfile if missing
                    if (!fileExists('Dockerfile')) {
                        writeFile file: 'Dockerfile', text: '''FROM openjdk:11-jre-slim
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]'''
                    }
                    
                    // Build and push Docker image
                    docker.withRegistry('https://index.docker.io/v1/', 'docker') {
                        def image = docker.build("${DOCKER_IMAGE}:${IMAGE_TAG}")
                        image.push()
                        image.push("latest")
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo "✅ Pipeline completed successfully!"
            echo "🐳 Docker image: ${DOCKER_IMAGE}:${IMAGE_TAG}"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
    }
}
