# Base image: Jenkins inbound agent (alpine-based)
FROM jenkins/inbound-agent:4.13-4-alpine as jnlp

# Switch to root to install dependencies
USER root

# Set environment variables
ENV JENKINS_AGENT_WORKDIR=/home/jenkins/agent \
    PYTHON_VENV=/opt/venv

# Update and install required tools
RUN apk add --no-cache \
    openjdk17 \
    python3 \
    py3-pip \
    py3-virtualenv \
    nodejs \
    npm \
    docker-cli \
    bash \
    git \
    curl \
    openssh \
    ca-certificates \
    zip \
    unzip \
    tar \
    shadow \
    build-base \
    libffi-dev \
    openssl-dev && \
    python3 -m venv $PYTHON_VENV && \
    $PYTHON_VENV/bin/pip install --no-cache-dir --upgrade pip setuptools wheel && \
    mkdir -p $JENKINS_AGENT_WORKDIR && \
    chown -R jenkins:jenkins $JENKINS_AGENT_WORKDIR

# Add Jenkins user to the Docker group for Docker CLI access
RUN addgroup -S docker && usermod -aG docker jenkins

# Switch back to the Jenkins user
USER jenkins

# Set working directory
WORKDIR $JENKINS_AGENT_WORKDIR

# Add Python virtual environment to PATH
ENV PATH="$PYTHON_VENV/bin:$PATH"

# Entry point for the Jenkins agent
ENTRYPOINT ["jenkins-agent"]
