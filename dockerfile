# Use Alpine as the base image
FROM alpine:latest

# Set environment variables
ENV JENKINS_AGENT_WORKDIR=/home/jenkins/agent \
    AGENT_JAR_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/latest/remoting-latest.jar \
    AGENT_JAR=/usr/share/jenkins/agent.jar

# Switch to root user to install dependencies
USER root

# Install required packages
RUN apk add --no-cache \
    openjdk17 \
    git \
    bash \
    curl \
    python3 \
    py3-pip \
    py3-virtualenv \
    nodejs \
    npm \
    docker-cli \
    make \
    openssh-client \
    build-base \
    libffi-dev \
    openssl-dev \
    jq && \
    # Create Jenkins user and working directory
    adduser -D -h $JENKINS_AGENT_WORKDIR jenkins && \
    mkdir -p $JENKINS_AGENT_WORKDIR && \
    chown -R jenkins:jenkins $JENKINS_AGENT_WORKDIR && \
    # Download Jenkins remoting agent JAR
    curl -fsSL $AGENT_JAR_URL -o $AGENT_JAR && \
    chmod 644 $AGENT_JAR && \
    chown jenkins:jenkins $AGENT_JAR

# Switch to Jenkins user
USER jenkins

# Set the working directory
WORKDIR $JENKINS_AGENT_WORKDIR

# Expose volume for the workspace
VOLUME $JENKINS_AGENT_WORKDIR
VOLUME /var/run/docker.sock

# Set entrypoint for the Jenkins inbound agent
ENTRYPOINT ["java", "-jar", "/usr/share/jenkins/agent.jar"]
