# Use Jenkins inbound agent with Alpine base
FROM jenkins/inbound-agent:latest-alpine

# Switch to root to install additional dependencies
USER root

# Environment variables
ENV JENKINS_AGENT_WORKDIR=/home/jenkins/agent \
    DOCKER_VERSION=latest

# Install Docker and required tools
RUN apk add --no-cache \
    openjdk17 \
    docker-cli \
    bash \
    git \
    curl \
    openssh-client \
    python3 \
    py3-pip \
    py3-virtualenv \
    nodejs \
    npm \
    build-base \
    libffi-dev \
    openssl-dev \
    ca-certificates \
    shadow \
    jq \
    zip \
    unzip && \
    # Create Jenkins agent workspace
    mkdir -p $JENKINS_AGENT_WORKDIR && \
    chown -R jenkins:jenkins $JENKINS_AGENT_WORKDIR && \
    # Add Jenkins user to the Docker group for CLI access
    groupadd -g 999 docker && \
    usermod -aG docker jenkins

# Switch back to Jenkins user
USER jenkins

# Set working directory
WORKDIR $JENKINS_AGENT_WORKDIR

# Use the default entrypoint from the base image
ENTRYPOINT ["jenkins-agent"]
