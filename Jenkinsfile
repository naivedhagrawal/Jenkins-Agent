pipeline {
    agent {
        kubernetes {
            yamlFile 'pod.yaml'
        }
    }
    stages {
        stage('docker') {
            steps {
                container('docker') {
                    sh "echo DOCKER_CONTAINER_ENV_VAR = ${CONTAINER_ENV_VAR}"
                    sh 'docker --version'
                }
            }
        }
    }
}
