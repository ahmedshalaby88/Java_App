pipeline {
    agent any

    tools {
        maven 'mvn-3-5-4'
    }

    environment {
        IMAGE_TAG = "v${BUILD_NUMBER}"
        GITHUB_CRED = credentials("github")
        DOCKER_CRED = credentials("docker")
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/ahmedshalaby88/Java_App.git',
                    credentialsId: 'github'
            }
        }

        stage('Build & Test') {
            steps {
                sh "mvn clean package -DskipTests"
                sh "mvn test"
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    docker.withRegistry('', 'docker') {
                        def image = docker.build("ahmedshalaby88/task2_cicd:${IMAGE_TAG}")
                        image.push()
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
            echo "✅ Build and Docker push completed successfully!"
        }
        failure {
            echo "❌ Build or Docker push failed!"
        }
    }
}
