/* groovylint-disable-next-line CompileStatic */
podTemplate(inheritFrom: 'jnlp', containers: [
    containerTemplate(name: 'maven', image: 'maven:latest' , ttyEnabled: true, command: 'cat', alwaysPullImage: true,)])
    environment {
        KUBERNETES_QUIET = 'true' }
{
    node(POD_LABEL) {
        stage('Checkout') {
            checkout scm
        }
        stage('Build') {
            container('maven') {
                sh 'mvn --version'
            }
        }
    }
}
 
