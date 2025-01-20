podTemplate(
  agentContainer: 'docker',
  agentInjection: true,
  showRawYaml: false,
  containers: [
    containerTemplate(name: 'docker', image: 'docker:latest', command: 'cat', ttyEnabled: true, volumes: [hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')]),
    containerTemplate(name: 'jnlp')
  ])

  {
    node(POD_LABEL) {
        environment {
            DOCKERHUB_CREDENTIALS = credentials(docker-hub-credentials)
        }
        stage('Code Clone') {
            checkout scm
        }
        stage('Build') {
            container('docker') {
                sh 'docker build -t jenkins-agent-all-in-one:latest .'
            }
        }
        stage('Push') {
            container('docker') {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh 'docker login -u $USERNAME -p $PASSWORD'
                    sh 'docker tag jenkins-agent-all-in-one:latest $DOCKERHUB_CREDENTIALS'
                    sh 'docker push $DOCKERHUB_CREDENTIALS'
                }
            }
        }
    }
    }