# Use the official OpenJDK 17 base image for Java 17
FROM openjdk:17-jdk-slim

# Set Tomcat version
ENV TOMCAT_VERSION 11.0.5
ENV TOMCAT_HOME /opt/apache-tomcat-${TOMCAT_VERSION}

# Install required utilities and download Tomcat 11.0.5
RUN apt-get update && apt-get install -y \
    wget \
    && wget https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.5/bin/apache-tomcat-11.0.5.tar.gz -O /tmp/tomcat.tar.gz \
    && tar xzf /tmp/tomcat.tar.gz -C /opt \
    && rm /tmp/tomcat.tar.gz \
    && ln -s /opt/apache-tomcat-${TOMCAT_VERSION} ${TOMCAT_HOME}

# Copy your WAR file into the Tomcat webapps directory
COPY InstantSplat.war ${TOMCAT_HOME}/webapps/

# Install RunPod SDK
RUN apt-get install -y python3 python3-pip && \
    pip3 install runpod

# Create a handler.py file for RunPod Serverless
COPY handler.py /handler.py

# Set the environment variable for Tomcat
ENV CATALINA_HOME ${TOMCAT_HOME}

# Expose the Tomcat port
EXPOSE 8080

# Start script to run both Tomcat and handle RunPod requests
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
