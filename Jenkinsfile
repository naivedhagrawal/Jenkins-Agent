/* groovylint-disable-next-line CompileStatic */
pipeline {
    agent {
        kubernetes {
            yamlFile 'https://github.com/naivedhagrawal/kubernetes_pods_yaml/blob/main/jnlp.yaml'
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
