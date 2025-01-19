# Use the Jenkins inbound agent base image
FROM jenkins/inbound-agent:latest

# Switch to root to install dependencies
USER root

# Environment variables
ENV JENKINS_AGENT_WORKDIR=/home/jenkins/agent \
    PYTHON_VENV=/opt/venv

# Update package sources and install tools
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    openjdk-17-jdk \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    build-essential \
    libffi-dev \
    libssl-dev \
    ca-certificates \
    curl \
    wget \
    unzip \
    zip \
    tar \
    git \
    openssh-client \
    docker.io \
    docker-compose-plugin \
    vim \
    jq \
    ruby-full \
    rsync && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    python3 -m venv $PYTHON_VENV && \
    $PYTHON_VENV/bin/pip install --no-cache-dir --upgrade pip setuptools wheel && \
    mkdir -p $JENKINS_AGENT_WORKDIR && \
    chown -R jenkins:jenkins $JENKINS_AGENT_WORKDIR

# Add Jenkins user to Docker group for Docker CLI access
RUN usermod -aG docker jenkins

# Add Python virtual environment to PATH
ENV PATH="$PYTHON_VENV/bin:$PATH"

# Switch back to Jenkins user
USER jenkins

# Set working directory
WORKDIR $JENKINS_AGENT_WORKDIR

# Default entrypoint from base image
ENTRYPOINT ["jenkins-agent"]
