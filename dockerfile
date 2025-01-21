# Start with a base image for a Jenkins agent
FROM jenkins/inbound-agent:latest

# Install essential build tools
USER root

# Update and install build dependencies
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
    openjdk-17-jdk \
    git \
    maven \
    gradle \
    nodejs \
    npm \
    curl \
    unzip \
    make \
    vim \
    zip \
    python3 \
    python3-pip \
    python3-venv && \
    apt-get clean

# Create a virtual environment for installing AWS CLI
RUN python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install awscli

# Install Docker (optional for Jenkins agents that need Docker to build)
RUN curl -fsSL https://get.docker.com | sh

# Ensure wget and unzip are installed for Gradle download
RUN apt-get update && \
    apt-get install -y wget unzip && \
    apt-get clean

RUN usermod -aG docker jenkins

# Set the environment variables for the tools
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV GRADLE_HOME=/opt/gradle/gradle-8.1.1
ENV PATH=$JAVA_HOME/bin:$GRADLE_HOME/bin:/venv/bin:$PATH

# Clean up unnecessary files
RUN rm -rf /tmp/* /var/lib/apt/lists/*

# Switch back to the jenkins user
USER jenkins

# Expose the Jenkins agent port (if needed)
EXPOSE 50000

# Set entrypoint for Jenkins agent
ENTRYPOINT ["jenkins-agent"]
