/* groovylint-disable-next-line CompileStatic */
pipeline {
    agent { kubernetes { label 'default' } }
    stages {
        stage('Build') {
            agent { kubernetes { label 'maven' } }
            steps {
                sh 'maven --version'
            }
        }
    }
}
