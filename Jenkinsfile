pipeline {
    agent any
    
    tools {
        maven 'mvn-3-5-4'
    }
    
    environment {
        IMAGE_TAG = "v${BUILD_NUMBER}"
        DOCKER_IMAGE = "ahmedshalaby88/task2_cicd"
        GITHUB_CRED = credentials("github")
        DOCKER_CRED = credentials("docker")
    }
    
    stages {
        
        stage('Environment Check') {
            steps {
                script {
                    echo "🔍 Environment Information:"
                    sh "java -version"
                    sh "mvn -version"
                    sh "docker --version"
                    echo "Build Number: ${BUILD_NUMBER}"
                    echo "Image Tag: ${IMAGE_TAG}"
                }
            }
        }
        
        stage('Checkout') {
            steps {
                echo "📥 Checking out source code..."
                git branch: 'main',
                    url: 'https://github.com/ahmedshalaby88/Java_App.git',
                    credentialsId: 'github'
                
                // List files to verify checkout
                sh "ls -la"
                sh "[ -f pom.xml ] && echo '✅ Maven project detected' || echo '❌ No pom.xml found'"
            }
        }
        
        stage('Build & Test') {
            steps {
                echo "🔨 Building and testing application..."
                script {
                    try {
                        sh "mvn clean package -DskipTests"
                        echo "✅ Build completed successfully"
                        
                        sh "mvn test"
                        echo "✅ Tests completed successfully"
                        
                        // Verify JAR file was created
                        sh "ls -la target/*.jar"
                        
                    } catch (Exception e) {
                        echo "❌ Build or test failed: ${e.getMessage()}"
                        throw e
                    }
                }
            }
            post {
                always {
                    // Publish test results if they exist
                    publishTestResults testResultsPattern: 'target/surefire-reports/*.xml',
                                     allowEmptyResults: true
                }
            }
        }
        
        stage('Archive Artifact') {
            steps {
                echo "📦 Archiving artifacts..."
                script {
                    if (fileExists('target/*.jar')) {
                        archiveArtifacts artifacts: 'target/*.jar'
                        echo "✅ Artifacts archived successfully"
                    } else {
                        error "❌ No JAR files found to archive"
                    }
                }
            }
        }
        
        stage('Docker Build & Push') {
            steps {
                echo "🐳 Building and pushing Docker image..."
                script {
                    try {
                        // Verify Dockerfile exists
                        if (!fileExists('Dockerfile')) {
                            error "❌ Dockerfile not found in repository root"
                        }
                        
                        // Build and push using Docker registry
                        docker.withRegistry('https://index.docker.io/v1/', 'docker') {
                            def image = docker.build("${DOCKER_IMAGE}:${IMAGE_TAG}")
                            image.push()
                            image.push("latest")
                            echo "✅ Docker image pushed successfully: ${DOCKER_IMAGE}:${IMAGE_TAG}"
                        }
                        
                    } catch (Exception e) {
                        echo "❌ Docker build/push failed: ${e.getMessage()}"
                        throw e
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo "🧹 Cleaning up workspace..."
            cleanWs()
        }
        success {
            echo """
            🎉 Pipeline completed successfully!
            ✅ Build: SUCCESS
            ✅ Tests: PASSED  
            ✅ Docker Image: ${DOCKER_IMAGE}:${IMAGE_TAG}
            🐳 Image pushed to Docker Hub
            """
        }
        failure {
            echo """
            💥 Pipeline failed!
            ❌ Check the logs above for error details
            🔍 Common issues:
            - Missing Dockerfile
            - Maven build failures
            - Docker credential issues
            - Network connectivity problems
            """
        }
    }
}
