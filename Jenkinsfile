podTemplate(
  agentContainer: 'jnlp',
  agentInjection: true,
  showRawYaml: false,
  containers: [
    containerTemplate(name: 'jnlp', image: 'jenkins/inbound-agent', command: 'cat', ttyEnabled: true, runAsUser: '0'),
  ]) {
    node(POD_LABEL) {
        environment {
            DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials')
        }
        stage('docker installation') {
            container('jnlp') {
                sh 'apt-get update'
                sh 'apt-get install -y docker.io'
                sh 'docker --version'
                sh 'sudo usermod -aG docker $USER'
                sh 'sudo newgrp docker'
            }
        }
        stage('Code Clone') {
            checkout scm
        }
        stage('Build') {
            container('jnlp') {
                sh 'sudo docker build -t jenkins-agent-all-in-one:latest .'
            }
        }
        stage('Push') {
            container('jnlp') {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh 'sudo docker login -u $USERNAME -p $PASSWORD'
                    sh 'sudo docker tag jenkins-agent-all-in-one:latest $DOCKERHUB_CREDENTIALS'
                    sh 'sudo docker push $DOCKERHUB_CREDENTIALS'
                }
            }
        }
    }
  }
