podTemplate(
    agentContainer: 'jnlp',
    agentInjection: true,
    showRawYaml: false,
    containers: [
        containerTemplate(
            name: 'jnlp', 
            image: 'jenkins/inbound-agent', 
            command: 'cat', 
            ttyEnabled: true, 
            runAsUser: '0's
        ),
    ]
) {
    node(POD_LABEL) {
        environment {
            DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials')
        }
        stage('docker installation') {
            container('jnlp') {
                // Installing Docker inside the container
                sh 'apt-get update'
                sh 'apt-get install -y docker.io'
                sh 'docker --version'
            }
        }
        stage('Code Clone') {
            // Cloning the code from SCM
            checkout scm
        }
        stage('Build') {
            container('jnlp') {
                // Building Docker image
                sh 'docker build -t jenkins-agent-all-in-one:latest .'
            }
        }
        stage('Push') {
            container('jnlp') {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    // Logging in to Docker Hub
                    sh 'docker login -u $USERNAME -p $PASSWORD'
                    
                    // Tagging the image with Docker Hub repository
                    sh 'docker tag jenkins-agent-all-in-one:latest $USERNAME/jenkins-agent-all-in-one:latest'
                    
                    // Pushing the Docker image to Docker Hub
                    sh 'docker push $USERNAME/jenkins-agent-all-in-one:latest'
                }
            }
        }
    }
}
