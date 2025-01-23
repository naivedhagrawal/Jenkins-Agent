FROM jenkins/inbound-agent:alpine

# Switch to root user to install dependencies
USER root

# Update and install essential build tools in one step
RUN apk update && \
    apk add openjdk17 \
    apk clean && \
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