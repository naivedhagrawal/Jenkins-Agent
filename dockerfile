# Use the official Docker image
FROM docker:latest

# Set environment variables
ENV JENKINS_AGENT_WORKDIR=/home/jenkins/agent \
    JENKINS_URL=http://<JENKINS_CONTROLLER_URL>:8080 \
    JENKINS_SECRET=<AGENT_SECRET> \
    JENKINS_AGENT_NAME=<AGENT_NAME>

# Install additional tools for Jenkins jobs
RUN apk add --no-cache \
    openjdk17 \
    git \
    curl \
    bash \
    openssh \
    ca-certificates \
    shadow && \
    mkdir -p $JENKINS_AGENT_WORKDIR && \
    addgroup -S jenkins && \
    adduser -S jenkins -G jenkins && \
    chown -R jenkins:jenkins $JENKINS_AGENT_WORKDIR

# Set up Docker permissions for the Jenkins user
RUN groupadd -g 999 docker && usermod -aG docker jenkins

# Download Jenkins agent jar
RUN curl -fsSL https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/latest/remoting-latest.jar -o /usr/share/jenkins/agent.jar && \
    chown jenkins:jenkins /usr/share/jenkins/agent.jar

# Switch to Jenkins user
USER jenkins

# Set the working directory
WORKDIR $JENKINS_AGENT_WORKDIR

# Entry point for Jenkins agent
ENTRYPOINT ["java", "-jar", "/usr/share/jenkins/agent.jar"]
