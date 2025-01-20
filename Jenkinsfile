podTemplate(
    showRawYaml: false,
    yaml: '''
              apiVersion: v1
              kind: Pod
              spec:
                volumes:
                - name: docker-socket
                  emptyDir: {}
                containers:
                - name: docker
                  image: docker:latest
                  readinessProbe:
                    exec:
                      command: [sh, -c, "ls -S /var/run/docker.sock"]
                  command:
                  - sleep
                  args:
                  - 99d
                  volumeMounts:
                  - name: docker-socket
                    mountPath: /var/run
                - name: docker-daemon
                  image: docker:dind
                  securityContext:
                    privileged: true
                  volumeMounts:
                  - name: docker-socket
                    mountPath: /var/run
''') {
  node(POD_LABEL) {
        environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials')
        }
    stages {
        stage('Code Clone') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t jenkins-agent-all-in-one:latest .'
                }
            }
        }
        stage('Push') {
            steps {
                script {
                    // Extract DockerHub credentials from Jenkins credentials store
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        // Login to Docker Hub
                        sh 'docker login -u $USERNAME -p $PASSWORD'

                        // Tag the Docker image correctly
                        sh 'docker tag jenkins-agent-all-in-one:latest $USERNAME/$REPOSITORY:latest'

                        // Push the Docker image to Docker Hub
                        sh 'docker push $USERNAME/$REPOSITORY:latest'
                    }
                }
            }
        }
    }
  }
}