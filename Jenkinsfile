pipeline {
    agent none  // Specify that the pipeline will run on a Kubernetes agent

    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials')
    }

    stages {
        stage('docker installation') {
            agent {
                kubernetes {
                    label 'docker-agent'  // Define a label for this pod template
                    defaultContainer 'jnlp'  // Default container to use (jnlp)
                    yaml '''
                    apiVersion: v1
                    kind: Pod
                    metadata:
                      name: jenkins-agent
                    spec:
                      containers:
                        - name: jnlp
                          image: 'jenkins/inbound-agent'
                          command: ['cat']
                          tty: true
                          securityContext:
                            runAsUser: 0
                          volumeMounts:
                            - mountPath: /var/run/docker.sock
                              name: docker-socket
                              readOnly: true
                      volumes:
                        - name: docker-socket
                          hostPath:
                            path: /var/run/docker.sock
                            type: Socket
                    '''
                }
            }
            steps {
                container('jnlp') {
                    // Install Docker inside the container
                    sh 'apt-get update'
                    sh 'apt-get install -y docker.io'
                    sh 'docker --version'
                }
            }
        }

        stage('Code Clone') {
            agent {
                kubernetes {
                    label 'docker-agent'
                    defaultContainer 'jnlp'
                    yaml '''
                    apiVersion: v1
                    kind: Pod
                    metadata:
                      name: jenkins-agent
                    spec:
                      containers:
                        - name: jnlp
                          image: 'jenkins/inbound-agent'
                          command: ['cat']
                          tty: true
                          securityContext:
                            runAsUser: 0
                          volumeMounts:
                            - mountPath: /var/run/docker.sock
                              name: docker-socket
                              readOnly: true
                      volumes:
                        - name: docker-socket
                          hostPath:
                            path: /var/run/docker.sock
                            type: Socket
                    '''
                }
            }
            steps {
                checkout scm
            }
        }

        stage('Build') {
            agent {
                kubernetes {
                    label 'docker-agent'
                    defaultContainer 'jnlp'
                    yaml '''
                    apiVersion: v1
                    kind: Pod
                    metadata:
                      name: jenkins-agent
                    spec:
                      containers:
                        - name: jnlp
                          image: 'jenkins/inbound-agent'
                          command: ['cat']
                          tty: true
                          securityContext:
                            runAsUser: 0
                          volumeMounts:
                            - mountPath: /var/run/docker.sock
                              name: docker-socket
                              readOnly: true
                      volumes:
                        - name: docker-socket
                          hostPath:
                            path: /var/run/docker.sock
                            type: Socket
                    '''
                }
            }
            steps {
                container('jnlp') {
                    // Build Docker image
                    sh 'docker build -t jenkins-agent-all-in-one:latest .'
                }
            }
        }

        stage('Push') {
            agent {
                kubernetes {
                    label 'docker-agent'
                    defaultContainer 'jnlp'
                    yaml '''
                    apiVersion: v1
                    kind: Pod
                    metadata:
                      name: jenkins-agent
                    spec:
                      containers:
                        - name: jnlp
                          image: 'jenkins/inbound-agent'
                          command: ['cat']
                          tty: true
                          securityContext:
                            runAsUser: 0
                          volumeMounts:
                            - mountPath: /var/run/docker.sock
                              name: docker-socket
                              readOnly: true
                      volumes:
                        - name: docker-socket
                          hostPath:
                            path: /var/run/docker.sock
                            type: Socket
                    '''
                }
            }
            steps {
                container('jnlp') {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        // Log into Docker Hub
                        sh 'docker login -u $USERNAME -p $PASSWORD'
                        
                        // Tag the Docker image
                        sh 'docker tag jenkins-agent-all-in-one:latest $USERNAME/jenkins-agent-all-in-one:latest'
                        
                        // Push Docker image to Docker Hub
                        sh 'docker push $USERNAME/jenkins-agent-all-in-one:latest'
                    }
                }
            }
        }
    }
}
