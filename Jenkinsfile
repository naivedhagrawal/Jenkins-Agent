/* groovylint-disable-next-line CompileStatic */
pipeline {
    agent any

    environment {
        // Jenkins secret containing Docker Hub credentials
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        // Replace with your Docker Hub username and image name
        DOCKER_IMAGE_NAME = 'naivedh/jenkins-agent-all-in-one'
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
                    sh 'docker build -t $DOCKER_IMAGE_NAME:$DOCKER_TAG .'
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    // Login to Docker Hub using credentials from Jenkins
                    docker.withRegistry('https://registry.hub.docker.com', DOCKER_HUB_CREDENTIALS) {
                        echo 'Successfully logged in to Docker Hub'
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the Docker image to Docker Hub
                    docker.withRegistry('https://registry.hub.docker.com', DOCKER_HUB_CREDENTIALS) {
                        sh 'docker push $DOCKER_IMAGE_NAME:$DOCKER_TAG'
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
