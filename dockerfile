# Use the official Jenkins inbound agent base image
FROM jenkins/inbound-agent:latest as jnlp

# Switch to root to install dependencies
USER root

# Environment variables
ENV JENKINS_AGENT_WORKDIR=/home/jenkins/agent \
    PYTHON_VENV=/opt/venv

# Update and install the latest tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Development tools
    openjdk-17-jdk \
    python3.10 \
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
    rsync \
    # Clean up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    # Set up Python virtual environment
    && python3 -m venv $PYTHON_VENV \
    && $PYTHON_VENV/bin/pip install --no-cache-dir --upgrade pip setuptools wheel \
    # Create Jenkins agent workspace
    && mkdir -p $JENKINS_AGENT_WORKDIR \
    && chown -R jenkins:jenkins $JENKINS_AGENT_WORKDIR

# Add Jenkins user to the Docker group for Docker CLI access
RUN usermod -aG docker jenkins

# Set PATH for Python virtual environment
ENV PATH="$PYTHON_VENV/bin:$PATH"

# Switch back to Jenkins user
USER jenkins

# Set working directory
WORKDIR $JENKINS_AGENT_WORKDIR

# Default entrypoint from base image
ENTRYPOINT ["jenkins-agent"]
