podTemplate(
  agentContainer: 'maven',
  agentInjection: true,
  containers: [
    containerTemplate(name: 'maven', image: 'maven:latest', command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'golang', image: 'golang:latest', command: 'sleep', args: '99d', ttyEnabled: true)
  ]) {

    environment {
        KUBERNETES_QUIET = 'true'  // Suppress Kubernetes plugin output
    }

    node(POD_LABEL) {
        stage('Get a Maven project') {
            git 'https://github.com/jenkinsci/kubernetes-plugin.git'
            container('maven') {
                stage('Build a Maven project') {
                    sh 'mvn -B -ntp clean install'
                }
            }
        }

        stage('Get a Golang project') {
            git url: 'https://github.com/hashicorp/terraform.git', branch: 'main'
            container('golang') {
                stage('Build a Go project') {
                    sh '''
                    mkdir -p /go/src/github.com/hashicorp
                    ln -s `pwd` /go/src/github.com/hashicorp/terraform
                    cd /go/src/github.com/hashicorp/terraform && make
                    '''
                }
            }
        }

    }
  }
