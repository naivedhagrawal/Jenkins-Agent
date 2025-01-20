podTemplate(
  agentContainer: 'maven',
  agentInjection: true,
  containers: [
    containerTemplate(name: 'maven', image: 'maven:latest', command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'golang', image: 'golang:latest', command: 'sleep', args: '99d', ttyEnabled: true)
  ]) {

    node(POD_LABEL) {
        stage('Get a Maven project') {
            git 'https://github.com/jenkinsci/kubernetes-plugin.git'
            container('maven') {
                stage('Build a Maven project') {
                    // Redirect stdout and stderr to a file to suppress console logs
                    sh '''
                    mvn -B -ntp clean install > build_logs.txt 2>&1
                    '''
                    echo "Maven build complete. Logs are saved in build_logs.txt"
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
                    cd /go/src/github.com/hashicorp/terraform && make > build_logs.txt 2>&1
                    '''
                    echo "Go project build complete. Logs are saved in build_logs.txt"
                }
            }
        }

    }
  }
