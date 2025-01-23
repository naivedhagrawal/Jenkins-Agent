FROM jenkins/inbound-agent:alpine

# Switch to root user to install dependencies
USER root

# Update and install essential build tools in one step
RUN echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/main" > /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories && \
    apk update && \
    apk add openjdk17 && \
    rm -rf /var/cache/apk/* /tmp/*

# Add Jenkins user to Docker group
RUN usermod -aG docker jenkins

# Set environment variables for the tools
ENV JAVA_HOME=/usr/lib/jvm/openjdk-17

# Expose the Jenkins agent port (if needed)
EXPOSE 50000

# Switch back to the Jenkins user
USER jenkins

# Set entrypoint for Jenkins agent
ENTRYPOINT ["jenkins-agent"]