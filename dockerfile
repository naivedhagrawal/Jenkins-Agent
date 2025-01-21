# Use the official Jenkins inbound agent Alpine-based image
FROM jenkins/inbound-agent:alpine

# Switch to root user to install dependencies
USER root

# Install essential build tools and Docker
RUN apk update && \
    apk add --no-cache \
    openjdk-17-jdk \
    git \
    maven \
    nodejs \
    npm \
    curl \
    unzip \
    python3 \
    py3-pip \
    bash \
    wget \
    docker && \
    python3 -m ensurepip && \
    pip3 install --upgrade pip && \
    apk add --no-cache --virtual .build-deps gcc musl-dev libffi-dev && \
    pip3 install awscli && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/*

# Install Docker using the Alpine package manager (optional if you need Docker inside the agent)
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh && \
    rm get-docker.sh

# Add Jenkins user to the Docker group to allow Docker execution
RUN addgroup -S jenkins && \
    adduser -S -G jenkins jenkins && \
    addgroup jenkins docker

# Set environment variables for Java and Python tools
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH=$JAVA_HOME/bin:/venv/bin:$PATH

# Expose the Jenkins agent port (default for Jenkins agents)
EXPOSE 50000

# Switch back to the Jenkins user
USER jenkins

# Set entrypoint for Jenkins agent
ENTRYPOINT ["jenkins-agent"]