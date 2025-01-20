pipeline {
  agent {
    kubernetes {
      yamlFile 'Pod.yaml'
    }
  }
  stages {
    stage('docker') {
      steps {
        container('docker') {
          sh 'echo DOCKER_CONTAINER_ENV_VAR = ${CONTAINER_ENV_VAR}'
          sh 'docker --version'
        }
      }
    }
  }
}