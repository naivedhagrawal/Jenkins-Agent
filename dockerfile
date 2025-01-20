FROM jenkins/inbound-agent:latest

# Install additional tools
USER root
RUN apt-get update && apt-get install -y \
    git \
    maven \
    gradle \
    nodejs \
    npm \
    python3 \
    python3-pip \
    openjdk-11-jdk

USER jenkins
