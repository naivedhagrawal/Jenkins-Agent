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
                    initialDelaySeconds: 5
                    periodSeconds: 5
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
                  command: ["dockerd"]
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
                sh 'docker images'
            }
        }
        stage('Push') {
            container('docker') {
                /* groovylint-disable-next-line LineLength */
                withCredentials([usernamePassword(credentialsId: 'docker_hub_up', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh 'docker login -u $USERNAME -p $PASSWORD'
                    sh 'echo #Username: $USERNAME'
                    sh 'docker tag jenkins-agent-all-in-one:latest naivedh/jenkins-agent-all-in-one:latest'
                    sh 'docker push naivedh/jenkins-agent-all-in-one:latest'
                }
            }
        }
    }
}
