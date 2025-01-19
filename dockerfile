# Base image for lightweight agents
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

# Add Jenkins user to Docker group
RUN groupadd -g 999 docker && \
    usermod -aG docker jenkins && \
    chmod 777 /var/run/docker.sock

# Set up the workspace
WORKDIR $JENKINS_AGENT_WORKDIR

# Switch back to Jenkins user
USER jenkins

# Define entrypoint for the Kubernetes plugin
ENTRYPOINT ["jenkins-agent"]
