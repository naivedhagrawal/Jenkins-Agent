# Use a smaller base image for Jenkins agent
FROM jenkins/inbound-agent:alpine

# Switch to root user to install dependencies
USER root

# Install essential build tools in one step
RUN apk update && \
    apk add --no-cache \
    openjdk17 \
    git \
    maven \
    gradle \
    nodejs \
    npm \
    curl \
    unzip \
    python3 \
    py3-pip \
    make \
    bash && \
    python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip awscli && \
    rm -rf /var/cache/apk/*

# Install Docker using the official script
RUN curl -fsSL https://get.docker.com | sh

# Add Jenkins user to Docker group
RUN addgroup jenkins docker

# Set environment variables for the tools
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH=$JAVA_HOME/bin:/opt/gradle/gradle-8.1.1/bin:/venv/bin:$PATH

# Expose Jenkins agent port
EXPOSE 50000

# Switch back to Jenkins user
USER jenkins

# Set entrypoint for Jenkins agent
ENTRYPOINT ["jenkins-agent"]
