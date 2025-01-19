/* groovylint-disable-next-line CompileStatic */
pipeline {
    agent any

    environment {
        // Jenkins secret containing Docker Hub credentials
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        // Replace with your Docker Hub username and image name
        DOCKER_IMAGE_NAME = 'naivedh/jenkins-agent-all-tools'
        DOCKER_TAG = 'latest'  // Or you can use a dynamic tag, e.g., Git commit hash
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout your repository
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t $jenkins-agent-all-tools:$latest .'
                }
            }
        }

        stage('Login and Push Docker Image') {
            steps {
                script {
                    // Login to Docker Hub and push the Docker image using credentials from Jenkins
                    docker.withRegistry('https://registry.hub.docker.com', DOCKER_HUB_CREDENTIALS) {
                        echo 'Successfully logged in to Docker Hub'
                        sh 'docker push $naivedh/jenkins-agent-all-tools:latest'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Docker image has been successfully pushed to Docker Hub!'
        }
        failure {
            echo 'Pipeline failed, check the logs for details.'
        }
    }
}
