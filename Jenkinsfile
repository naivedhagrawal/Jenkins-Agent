pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: maven
    image: maven:latest
    command: ['cat']
    tty: true
  - name: golang
    image: golang:latest
    command: ['sleep']
    args: ['99d']
    tty: true
"""
        }
    }

    environment {
        KUBERNETES_QUIET = 'true'  // Suppress Kubernetes plugin output
    }

    stages {
        stage('Get a Maven project') {
            steps {
                container('maven') {
                    script {
                        git 'https://github.com/jenkinsci/kubernetes-plugin.git'
                        sh 'mvn -B -ntp clean install'
                    }
                }
            }
        }

        stage('Get a Golang project') {
            steps {
                container('golang') {
                    script {
                        git url: 'https://github.com/hashicorp/terraform.git', branch: 'main'
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
}
