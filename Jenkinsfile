podTemplate(
  agentContainer: 'jnlp',
  agentInjection: true,
  showRawYaml: false,
  containers: [
    containerTemplate(name: 'jnlp', image: 'jenkins/inbound-agent', command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'alpine', image: 'alpine:latest', command: 'cat', ttyEnabled: true)
  ]) {

  node(POD_LABEL) {
      stage('Build') {
          container('alpine') {
              sh '''
              echo "http://mirror1.hs-esslingen.de/pub/Mirrors/alpine/v3.21/main" > /etc/apk/repositories
              echo "http://mirror1.hs-esslingen.de/pub/Mirrors/alpine/v3.21/community" >> /etc/apk/repositories
              apk update && apk add --no-cache openjdk11 docker-cli
              '''
              sh 'docker --version'
          }
      }
  }
}
