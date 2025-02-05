pipeline {
    agent any

    tools{
        maven 'maven'
    }

    stages{
        stage('Check and remove container'){
            steps{
                script{
                    def containerExists = sh(script: "docker ps -q -f name=varshi", returnStdout: true).trim()
                    if (containerExists) {
                    sh "docker stop varshi"
                    sh "docker rm varshi"
                    }
                }
            }
        }
        stage('Build package'){
            steps{
                sh 'mvn clean package'
            }
        }
        stage('Create image'){
            steps{
                sh 'sudo docker build -t app /var/lib/jenkins/workspace/webapp/'
            }
        }
        stage('Assign tag'){
            steps{
                sh 'docker tag app varshitha146/app'
            }
        }
        stage('Push to dockerhub'){
            steps{
                sh 'echo "Varshi@14" | docker login -u "varshitha146" --password-stdin'
                sh 'docker push varshitha146/app'
            }
        }
        stage('Remove images'){
            steps{
                sh 'docker rmi -f $(docker images -q)'
            }
        }
        stage('Pull image from DockerHub'){
            steps{
                sh 'docker pull varshitha146/app'
            }
        }
        stage('Run a container'){
            steps{
                sh 'docker run -it -d --name varshi -p 8081:8080 varshitha146/app'
            }
        }
    }
    post {
        success {
            echo 'Deployment successful'
        }
        failure {
            sh 'docker rm -f varshi'
        }
        always{
            echo 'Deployed'
        }
    }

}