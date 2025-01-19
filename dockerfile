# Use the official Jenkins inbound agent image as the base
FROM jenkins/inbound-agent:latest

# Switch to root to install dependencies
USER root

# Set environment variables
ENV JENKINS_AGENT_WORKDIR=/home/jenkins/agent \
    DOCKER_VERSION=20.10.24

# Update and install dependencies
RUN dnf -y update && \
    dnf -y install \
    java-11-openjdk \
    git \
    curl \
    bash \
    openssh \
    python3 \
    python3-pip \
    nodejs \
    npm \
    gcc \
    make \
    libffi-devel \
    openssl-devel \
    zip \
    unzip \
    tar \
    shadow-utils \
    docker \
    wget \
    podman \
    findutils \
    vim && \
    pip3 install --no-cache-dir --upgrade pip setuptools wheel && \
    dnf clean all

# Set up Docker CLI (if required)
RUN curl -fsSL https://download.docker.com/linux/static/stable/$(uname -m)/docker-${DOCKER_VERSION}.tgz | tar -xz -C /usr/local/bin --strip-components=1 && \
    chmod +x /usr/local/bin/docker

# Create workspace directory
RUN mkdir -p $JENKINS_AGENT_WORKDIR && \
    chown -R jenkins:jenkins $JENKINS_AGENT_WORKDIR

# Switch back to the Jenkins user
USER jenkins

# Set working directory
WORKDIR $JENKINS_AGENT_WORKDIR

# Expose the volume for Jenkins workspace
VOLUME $JENKINS_AGENT_WORKDIR

# Use the default entrypoint from the base image
ENTRYPOINT ["jenkins-agent"]
