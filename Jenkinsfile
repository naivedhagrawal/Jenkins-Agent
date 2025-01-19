/* groovylint-disable-next-line CompileStatic */
pipeline {
    agent {
        kubernetes {
            yamlFile 'pod.yaml'
        }
    }
    stages {
        stage('Run maven') {
        /* groovylint-disable-next-line ClosureStatementOnOpeningLineOfMultipleLineClosure */
            steps {
                container('maven') {
                    sh 'mvn -version'
                }
            }
        }
        /* groovylint-disable-next-line SpaceBeforeClosingBrace */
        stage('Run busybox') {
            steps {
                container('busybox') {
                    sh '/bin/busybox'
                }
            }
        }
        
    }
}
