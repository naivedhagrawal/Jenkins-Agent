# Use the latest Docker-in-Docker image as the base
FROM docker:24.0.5-dind

# Install required dependencies
RUN apk add --no-cache \
    openjdk17 \
    git \
    curl \
    bash \
    openssh \
    shadow \
    ca-certificates

# Set environment variables
ENV JENKINS_AGENT_WORKDIR=/home/jenkins/agent
ENV JENKINS_HOME=/home/jenkins

# Create Jenkins user and workspace
RUN addgroup -S jenkins && \
    adduser -S jenkins -G jenkins && \
    mkdir -p $JENKINS_AGENT_WORKDIR && \
    chown -R jenkins:jenkins $JENKINS_AGENT_WORKDIR

# Download Jenkins agent jar
ADD https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/3104.1/remoting-3104.1.jar /usr/share/jenkins/agent.jar

# Change ownership of the agent jar
RUN chown jenkins:jenkins /usr/share/jenkins/agent.jar

# Add Jenkins user to the Docker group
RUN usermod -aG docker jenkins

# Switch to Jenkins user
USER jenkins

# Set the working directory
WORKDIR $JENKINS_AGENT_WORKDIR

# Expose volume for Jenkins workspace
VOLUME $JENKINS_AGENT_WORKDIR

# Set the entrypoint for the Kubernetes plugin
ENTRYPOINT ["java", "-jar", "/usr/share/jenkins/agent.jar"]
