
pipeline {
  agent {
    kubernetes {
      yamlFile 'pod.yaml'
    }
  }
  stages {
    stage('Run maven') {
      steps {
        container('maven') {
          sh 'mvn -version'
        }
        container('busybox') {
          sh '/bin/busybox'
        }
        container('docker') {
            sh 'docker --version'
          }
        }
      }
    }
  }
