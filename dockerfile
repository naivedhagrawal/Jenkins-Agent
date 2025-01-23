FROM jenkins/inbound-agent:alpine

# Switch to root user to install dependencies
USER root

# Install essential build tools 
RUN apk update && \
    apk add --no-cache \
    git \
    maven \
    gradle \
    nodejs \
    npm \
    curl \
    unzip \
    python3 \
    py3-pip \
    make 

# Ensure pip is installed for Python 3
RUN python3 -m ensurepip

# Install awscli
RUN pip3 install --no-cache --upgrade pip awscli

# Set environment variables for the tools 
# (Adjust paths if necessary)
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk 
ENV PATH=$JAVA_HOME/bin:/opt/gradle/gradle-8.1.1/bin:$PATH

# Expose Jenkins agent port
EXPOSE 50000

# Set entrypoint for Jenkins agent
ENTRYPOINT ["jenkins-agent"]