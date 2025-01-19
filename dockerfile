# Use the official Jenkins inbound agent as the base image
FROM jenkins/inbound-agent:latest-alpine

# Switch to root to install additional dependencies
USER root

# Set environment variables
ENV JENKINS_AGENT_WORKDIR=/home/jenkins/agent

# Update and install dependencies
RUN apk add --no-cache \
    openjdk11 \
    git \
    curl \
    bash \
    openssh \
    python3 \
    py3-pip \
    nodejs \
    npm \
    gcc \
    g++ \
    make \
    libffi-dev \
    openssl-dev \
    docker-cli \
    zip \
    unzip \
    tar \
    ca-certificates \
    shadow \
    vim && \
    pip3 install --no-cache-dir --upgrade pip setuptools wheel && \
    mkdir -p $JENKINS_AGENT_WORKDIR && \
    chown -R jenkins:jenkins $JENKINS_AGENT_WORKDIR

# Switch back to the Jenkins user
USER jenkins

# Set working directory
WORKDIR $JENKINS_AGENT_WORKDIR

# Expose volume for Jenkins workspace
VOLUME $JENKINS_AGENT_WORKDIR

# Use the default entrypoint from the base image
ENTRYPOINT ["jenkins-agent"]
