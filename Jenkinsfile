podTemplate(
  agentContainer: 'jnlp',
  agentInjection: true,
  showRawYaml: false,
  containers: [
    containerTemplate(name: 'jnlp', image: 'jenkins/inbound-agent', command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'alpine', image: 'alpine:latest', command: 'cat', ttyEnabled: true)
  ])

  {
    node(POD_LABEL) {
        stage('Build') {
            container('alpine') {
                sh 'echo "Hello, World!"'
                sh 'apk add --no-cache curl'
                sh 'apk add --no-cache docker-cli'
                sh 'docker --version'
            }
        }
    }
}