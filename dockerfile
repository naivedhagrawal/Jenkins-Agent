# Use the official Jenkins inbound agent base image
FROM jenkins/inbound-agent:latest

# Switch to root to install additional dependencies
USER root

# Set environment variables
ENV JENKINS_AGENT_WORKDIR=/home/jenkins/agent \
    DEBIAN_FRONTEND=noninteractive

# Update the system and install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    default-jre \
    git \
    curl \
    bash \
    openssh-client \
    python3 \
    python3-pip \
    nodejs \
    npm \
    gcc \
    make \
    libffi-dev \
    libssl-dev \
    docker.io \
    unzip \
    zip \
    tar \
    ca-certificates \
    software-properties-common \
    build-essential \
    vim && \
    pip3 install --no-cache-dir --upgrade pip setuptools wheel && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create Jenkins agent workspace directory
RUN mkdir -p $JENKINS_AGENT_WORKDIR && \
    chown -R jenkins:jenkins $JENKINS_AGENT_WORKDIR

# Switch back to the Jenkins user
USER jenkins

# Set the working directory
WORKDIR $JENKINS_AGENT_WORKDIR

# Expose volume for Jenkins workspace
VOLUME $JENKINS_AGENT_WORKDIR

# Use the default entrypoint from the base image
ENTRYPOINT ["jenkins-agent"]
