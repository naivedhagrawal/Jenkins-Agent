# Use the official Jenkins inbound agent base image
FROM jenkins/inbound-agent:4.13-4-alpine

# Set environment variables
ENV JENKINS_AGENT_WORKDIR=/home/jenkins/agent \
    JENKINS_URL=http://<JENKINS_CONTROLLER_URL>:8080 \
    JENKINS_SECRET=<AGENT_SECRET> \
    JENKINS_AGENT_NAME=<AGENT_NAME>

# Install additional tools
USER root
RUN apk add --no-cache \
    docker-cli \
    bash \
    git \
    curl \
    openjdk17 \
    shadow

# Add Jenkins to the Docker group for Docker CLI access
RUN usermod -aG docker jenkins

# Set working directory
USER jenkins
WORKDIR $JENKINS_AGENT_WORKDIR

# Use the entrypoint from the base image
ENTRYPOINT ["jenkins-agent"]
