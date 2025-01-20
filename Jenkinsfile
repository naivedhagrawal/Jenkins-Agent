/* groovylint-disable-next-line CompileStatic */
podTemplate(inheritFrom: 'jnlp', containers: [
    containerTemplate(name: 'maven', image: 'maven:latest' , ttyEnabled: true, command: 'cat'),
  ]) {
    node(POD_LABEL) {
        stage('Checkout') {
            checkout scm
        }
        stage('Build') {
            container('maven') {
                sh 'mvn -B -DskipTests clean package'
            }
        }
    }
  }
