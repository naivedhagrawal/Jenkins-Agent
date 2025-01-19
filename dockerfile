# Use the official Jenkins inbound agent base image
FROM jenkins/inbound-agent:latest-alpine

# Switch to root to install additional dependencies
USER root

# Set environment variables
ENV JENKINS_AGENT_WORKDIR=/home/jenkins/agent \
    PYTHON_VENV=/opt/venv

# Update and install dependencies
RUN apk add --no-cache \
    openjdk11 \
    git \
    curl \
    bash \
    openssh \
    python3 \
    py3-pip \
    py3-virtualenv \
    nodejs \
    npm \
    gcc \
    g++ \
    make \
    libffi-dev \
    openssl-dev \
    docker \
    docker-compose \
    zip \
    unzip \
    tar \
    ca-certificates \
    shadow \
    vim && \
    # Set up Python virtual environment
    python3 -m venv $PYTHON_VENV && \
    $PYTHON_VENV/bin/pip install --no-cache-dir --upgrade pip setuptools wheel && \
    # Create Jenkins workspace directory
    mkdir -p $JENKINS_AGENT_WORKDIR && \
    chown -R jenkins:jenkins $JENKINS_AGENT_WORKDIR

# Add Jenkins user to the docker group (ensure docker group exists)
RUN if ! getent group docker; then \
        addgroup -S docker; \
    fi && \
    usermod -aG docker jenkins

# Switch to Jenkins user
USER jenkins

# Set up the Python virtual environment for all users
ENV PATH="$PYTHON_VENV/bin:$PATH"

# Set working directory
WORKDIR $JENKINS_AGENT_WORKDIR

# Expose volume for Jenkins workspace
VOLUME $JENKINS_AGENT_WORKDIR

# Use the default entrypoint from the base image
ENTRYPOINT ["jenkins-agent"]
