/* groovylint-disable-next-line CompileStatic */
pipeline {
    agent any
    stages {
        stage('Build') {
            agent { kubernetes { label 'maven' } }
            steps {
                sh 'maven --version'
            }
        }
    }
}
