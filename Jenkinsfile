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
    /* groovylint-disable-next-line Indentation */
    node(POD_LABEL) {
        environment {
            DOCKERHUB_CREDENTIALS = credentials('docker_hub_up')
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
                /* groovylint-disable-next-line LineLength */
                withCredentials([usernamePassword(credentialsId: 'docker_hub_up', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh 'docker login -u $USERNAME -p $PASSWORD'
                    sh 'docker tag jenkins-agent-all-in-one:latest $DOCKERHUB_CREDENTIALS'
                    sh 'docker push $DOCKERHUB_CREDENTIALS'
                }
            }
        }
    }
}
