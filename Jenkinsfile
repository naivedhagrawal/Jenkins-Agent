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
            }
        }
        stage('Run busybox') {
            steps {
                container('busybox') {
                    sh '/bin/busybox'
                }
            }
        }
        
    }
}
