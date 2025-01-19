# Use Alpine as the base image
FROM alpine:latest

# Set environment variables
ENV JENKINS_AGENT_WORKDIR=/home/jenkins/agent \
    AGENT_JAR_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/3107.1/remoting-3107.1.jar \
    AGENT_JAR=/usr/share/jenkins/agent.jar

# Switch to root user to install dependencies
USER root

# Update repositories and install dependencies
RUN apk update && apk add --no-cache \
    openjdk17 \
    git \
    bash \
    curl \
    python3 \
    py3-pip \
    py3-virtualenv \
    nodejs \
    npm \
    make \
    docker-cli \
    openssh-client \
    build-base \
    libffi-dev \
    openssl-dev \
    jq && \
    # Manually create home directory
    mkdir -p $JENKINS_AGENT_WORKDIR && \
    adduser -D -h $JENKINS_AGENT_WORKDIR jenkins && \
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

# Set entrypoint for the Jenkins inbound agent
ENTRYPOINT ["java", "-jar", "/usr/share/jenkins/agent.jar"]
