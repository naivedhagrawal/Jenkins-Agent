pipeline {
    agent any
    stages {
        stage('Build') {
            agent maven
            steps {
                sh 'maven --version'
            }
        }
    }
}
