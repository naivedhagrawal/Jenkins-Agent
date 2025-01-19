# Base image for Jenkins Kubernetes agent
FROM jenkins/inbound-agent

# Switch to root to install additional tools
USER root

# Set environment variables
ENV JENKINS_AGENT_WORKDIR=/home/jenkins/agent \
    AGENT_JAR=/usr/share/jenkins/agent.jar

# Install essential dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    docker.io \
    git \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    unzip \
    zip \
    vim \
    jq && \
    # Clean up APT cache to reduce image size
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Add Jenkins user to Docker group if it exists, else create it
RUN getent group docker || groupadd -g 999 docker && \
    usermod -aG docker jenkins && \
    mkdir -p $JENKINS_AGENT_WORKDIR && \
    chown -R jenkins:jenkins $JENKINS_AGENT_WORKDIR

# Set up Docker socket permissions (if applicable)
RUN chmod 777 /var/run/docker.sock || true

# Set the working directory
WORKDIR $JENKINS_AGENT_WORKDIR

# Switch back to Jenkins user
USER jenkins

# Define entrypoint for the Kubernetes plugin
ENTRYPOINT ["jenkins-agent"]
