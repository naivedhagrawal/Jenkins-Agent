/* groovylint-disable-next-line CompileStatic */
pipeline {
    agent {
        kubernetes {
            /* groovylint-disable-next-line LineLength */
            yamlFile 'https://github.com/naivedhagrawal/kubernetes_pods_yaml/blob/30b8cc55a972f45b6294fbf3d6ad7a7f880f22af/jnlp.yaml'
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
