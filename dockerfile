# Use the official Jenkins inbound agent base image
FROM jenkins/inbound-agent:latest

# Set working directory for the Jenkins agent
ENV JENKINS_AGENT_WORKDIR=/home/jenkins/agent

# Switch to root to install Docker CLI
USER root

# Install Docker CLI and other minimal tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    docker.io \
    ca-certificates \
    curl \
    bash && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Ensure the 'docker' group exists and add 'jenkins' user to it
RUN mkdir -p $JENKINS_AGENT_WORKDIR && \
    chown -R jenkins:jenkins $JENKINS_AGENT_WORKDIR && \
    if ! getent group docker > /dev/null; then groupadd -g 999 docker; fi && \
    usermod -aG docker jenkins

# Switch back to Jenkins user
USER jenkins

# Set working directory
WORKDIR $JENKINS_AGENT_WORKDIR

# Use the default entrypoint for Jenkins JNLP agent
ENTRYPOINT ["jenkins-agent"]
