pipeline {
    agent any

    tools {
        maven 'Maven-Name' // Replace with your Maven installation name
    }

    stages {
        stage('Check and remove container') {
            steps {
                script {
                    def containerExists = sh(script: "docker ps -q -f name=varshi", returnStdout: true).trim()
                    if (containerExists?.trim()) {
                        sh "docker stop varshi"
                        sh "docker rm varshi"
                    }
                }
            }
        }
        stage('Build package') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Create image') {
            steps {
                sh 'docker build -t app /var/lib/jenkins/workspace/webapp/'
            }
        }
        stage('Assign tag') {
            steps {
                sh 'docker tag app varshitha146/app'
            }
        }
        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USER" --password-stdin'
                }
                sh 'docker push varshitha146/app'
            }
        }
        stage('Remove old images') {
            steps {
                sh 'docker rmi -f varshitha146/app || true'  // Avoid errors if image doesn't exist
            }
        }
        stage('Pull image from DockerHub') {
            steps {
                sh 'docker pull varshitha146/app'
            }
        }
        stage('Run a container') {
            steps {
                sh 'docker run -it -d --name varshi -p 8081:8080 varshitha146/app'
            }
        }
    }

    post {
        success {
            echo 'Deployment successful'
        }
        failure {
            script {
                sh 'docker rm -f varshi || true' // Prevent failure if container doesn't exist
            }
            echo 'Deployment failed'
        }
        always {
            echo 'Deployment process completed'
        }
    }
}
