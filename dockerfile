FROM jenkins/inbound-agent:alpine

# Switch to root user to install dependencies
USER root

# Update and install essential build tools in one step
RUN apk update && \
    apk add \
        openjdk17 \
        git \
        maven \
        gradle \
        nodejs \
        npm \
        curl \
        unzip \
        make \
        python3 \
        py3-pip \
        py3-venv \
        wget && \
    apk clean && \
    rm -rf /var/cache/apk/* /tmp/*

# Install AWS CLI in a Python virtual environment
RUN python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install awscli

# Install Docker (use the official Docker install script for a more secure install)
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh && \
    rm get-docker.sh

# Add Jenkins user to Docker group
RUN usermod -aG docker jenkins

# Set environment variables for the tools
ENV JAVA_HOME=/usr/lib/jvm/openjdk-17
ENV GRADLE_HOME=/opt/gradle/gradle-8.1.1
ENV PATH=$JAVA_HOME/bin:$GRADLE_HOME/bin:/venv/bin:$PATH

# Expose the Jenkins agent port (if needed)
EXPOSE 50000

# Switch back to the Jenkins user
USER jenkins

# Set entrypoint for Jenkins agent
ENTRYPOINT ["jenkins-agent"]