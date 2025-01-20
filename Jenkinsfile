podTemplate(
  agentContainer: 'maven',
  agentInjection: true,
  showRawYaml: false,
  containers: [
    containerTemplate(name: 'maven', image: 'maven:latest', command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'golang', image: 'golang:latest', command: 'sleep', args: '99d', ttyEnabled: true)
  ])

  {
    node(POD_LABEL) {
        stage('Get a Maven project') {
            git 'https://github.com/jenkinsci/kubernetes-plugin.git'
            container('maven') {
                stage('Build a Maven project') {
                    sh 'mvn --version'
                }
            }
        }
    }
        stage('Get a Golang project') {
            git url: 'https://github.com/hashicorp/terraform.git', branch: 'main'
            container('golang') {
                stage('Build a Go project') {
                    sh 'go version'
                }
            }
        }
    }