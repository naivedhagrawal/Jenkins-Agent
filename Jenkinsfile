/* groovylint-disable-next-line CompileStatic */
pipeline {
    agent {
        kubernetes {
            yamlFile 'https://raw.githubusercontent.com/naivedhagrawal/kubernetes_pods_yaml/refs/heads/main/jnlp.yaml'
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
