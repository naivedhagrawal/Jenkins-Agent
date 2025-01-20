podTemplate(yaml: '''
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