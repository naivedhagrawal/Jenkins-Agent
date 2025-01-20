podTemplate(
  agentContainer: 'jnlp',
  agentInjection: true,
  showRawYaml: false,
  containers: [
    containerTemplate(name: 'jnlp', image: 'jenkins/inbound-agent', command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'alpine', image: 'alpine:latest', command: 'cat', ttyEnabled: true)
  ]) {
    node(POD_LABEL) {
        environment {
            DOCKERHUB_CREDENTIALS = credentials(docker - hub - credentials)
        }
        stage('docker installation') {
            container('alpine') {
                sh '''
              echo "http://mirror1.hs-esslingen.de/pub/Mirrors/alpine/v3.21/main" > /etc/apk/repositories
              echo "http://mirror1.hs-esslingen.de/pub/Mirrors/alpine/v3.21/community" >> /etc/apk/repositories
              apk update && apk add --no-cache docker-cli
              '''
                sh 'docker --version'
            }
        }
        stage('Code Clone') {
            checkout scm
        }
        stage('Build') {
            container('alpine') {
                sh 'docker build -t jenkins-agent-all-in-one:latest .'
            }
        }
        stage('Push') {
            container('alpine') {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh 'docker login -u $USERNAME -p $PASSWORD'
                    sh 'docker tag jenkins-agent-all-in-one:latest $DOCKERHUB_CREDENTIALS'
                    sh 'docker push $DOCKERHUB_CREDENTIALS'
                }
            }
        }
    }
  }
