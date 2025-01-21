FROM jenkins/inbound-agent:alpine

USER root

# Install basic tools
RUN apk update && apk add --no-cache \
    bash \
    curl \
    wget \
    unzip \
    python3 \
    py3-pip

# Switch back to the Jenkins user
USER jenkins

# Set the working directory
WORKDIR /home/jenkins/agent

# Run the Jenkins agent
ENTRYPOINT ["jenkins-agent"]
