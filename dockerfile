# Use the official Jenkins inbound agent Alpine-based image
FROM jenkins/inbound-agent:alpine

# Switch to root user to install dependencies
USER root

# Update the Alpine repositories and force a refresh
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.18/main" > /etc/apk/repositories && \
    apk update && \
    echo "Alpine repositories updated"

# Install essential tools
RUN apk add --no-cache \
    bash \
    curl \
    wget \
    unzip \
    python3 \
    py3-pip && \
    echo "Basic tools installed successfully"

# Install Java (openjdk11)
RUN apk add --no-cache openjdk11 && \
    echo "Java installed successfully"

# Install development tools and other dependencies
RUN apk add --no-cache \
    git \
    maven \
    nodejs \
    npm && \
    echo "Development tools installed successfully"

# Install AWS CLI and remove build dependencies
RUN apk add --no-cache --virtual .build-deps gcc musl-dev libffi-dev && \
    python3 -m ensurepip && \
    pip3 install --upgrade pip && \
    pip3 install awscli && \
    apk del .build-deps && \
    echo "AWS CLI installed and build dependencies removed"

# Install Docker using get-docker.sh script
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh && \
    rm get-docker.sh && \
    echo "Docker installed successfully"

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
