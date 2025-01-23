FROM jenkins/inbound-agent:alpine

# Switch to root user to install dependencies
USER root

# Add the latest repository and install packages
RUN echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/main" > /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories && \
    apk update && \
    apk add openjdk17 git maven gradle nodejs npm curl unzip make python3 python3-pip python3-venv wget && \
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
RUN addgroup -S docker && adduser -S jenkins -G docker

# Set environment variables for the tools
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV GRADLE_HOME=/opt/gradle/gradle-8.1.1
ENV PATH=$JAVA_HOME/bin:$GRADLE_HOME/bin:/venv/bin:$PATH

# Expose the Jenkins agent port (if needed)
EXPOSE 50000

# Switch back to the Jenkins user
USER jenkins

# Set entrypoint for Jenkins agent
ENTRYPOINT ["jenkins-agent"]
