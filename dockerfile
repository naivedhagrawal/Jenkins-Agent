# Use the official Jenkins inbound agent Alpine-based image
FROM jenkins/inbound-agent:alpine

# Switch to root user to install dependencies
USER root

# Install essential build tools and Docker
RUN apk update && \
    apk add --no-cache \
    openjdk11 \
    git \
    maven \
    nodejs \
    npm \
    curl \
    unzip \
    python3 \
    py3-pip \
    bash \
    wget && \
    apk add --no-cache --virtual .build-deps gcc musl-dev libffi-dev && \
    python3 -m ensurepip && \
    pip3 install --upgrade pip && \
    pip3 install awscli && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/*

# Install Docker using the get-docker.sh script (ensure latest Docker version)
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh && \
    rm get-docker.sh

# Add Jenkins user to Docker group
RUN addgroup -S jenkins && \
    adduser -S -G jenkins jenkins && \
    addgroup jenkins docker

# Set environment variables for Java and Python tools
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV PATH=$JAVA_HOME/bin:/venv/bin:$PATH

# Expose Jenkins agent port
EXPOSE 50000

# Switch back to the Jenkins user
USER jenkins

# Set entrypoint for Jenkins agent
ENTRYPOINT ["jenkins-agent"]
