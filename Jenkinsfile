@Library('data-lib')_

pipeline{
    
    agent{
        label "agent-0"
    }

    tools {
      maven 'mvn-3-5-4'
    }

    environment {
        DOCKER_USER = credentials("docker-username")
        DOCKER_PASS = credentials("docker-password")
    }

    stages{
        stage("Build App"){
            steps{
                script{
                    def maven = new ed.iti.mvn()
                    maven.build("package install")
                }
            }
        }
        // stage("Test App"){
        //     steps{
        //         script{
        //             def maven = new ed.iti.mvn()
        //             maven.test(Nu)
        //         }
        //     }
        // }
        stage("Archive Jar"){
            steps{
                archiveArtifacts artifacts: 'target/*.jar', followSymlinks: false
            }
        }
        stage("Build Docker Image"){
            steps{
                script{
                    def dockeriti = new org.iti.docker()
                    dockeriti.build("hassaneid/data-iti", "v${IMAGE_NUM}")
                }
            }
        }
        stage("Docker Login"){
            steps{
                script{
                    def dockeriti = new org.iti.docker()
                    dockeriti.login("${DOCKER_USER}", "${DOCKER_PASS}")
                }
            }
        }
        stage("Docker push"){
            steps{
                script{
                    def dockeriti = new org.iti.docker()
                    dockeriti.push("hassaneid/data-iti", "v${IMAGE_NUM}")
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo "success"
        }
        failure {
            echo "failure"
        }
    }

}