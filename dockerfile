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
    vim \
    zip \
    python3 \
    python3-pip \
    && apt-get clean

# Install Docker (optional for Jenkins agents that need Docker to build)
RUN curl -fsSL https://get.docker.com | sh

# Install AWS CLI (optional for cloud deployments)
RUN pip3 install awscli --upgrade

# Install the latest version of Gradle (optional)
RUN wget https://services.gradle.org/distributions/gradle-8.1.1-bin.zip -P /tmp && \
    unzip -d /opt/gradle /tmp/gradle-8.1.1-bin.zip && \
    ln -s /opt/gradle/gradle-8.1.1/bin/gradle /usr/bin/gradle

# Set the environment variables for the tools
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV GRADLE_HOME=/opt/gradle/gradle-8.1.1
ENV PATH=$JAVA_HOME/bin:$GRADLE_HOME/bin:$PATH

# Clean up unnecessary files
RUN rm -rf /tmp/*

# Switch back to the jenkins user
USER jenkins

# Expose the Jenkins agent port (if needed)
EXPOSE 50000

# Set entrypoint for Jenkins agent
ENTRYPOINT ["jenkins-agent"]
