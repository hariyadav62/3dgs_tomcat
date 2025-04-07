#!/bin/bash

# Check if we're running in a RunPod serverless environment
if [ -d "/runpod-volume" ]; then
    # Create logs directory in network volume if it doesn't exist
    mkdir -p /runpod-volume/tomcat-logs
    
    # Remove the default logs directory and symlink to network volume
    rm -rf ${CATALINA_HOME}/logs
    ln -sf /runpod-volume/tomcat-logs ${CATALINA_HOME}/logs
    
    echo "Tomcat logs will be stored in network volume at /runpod-volume/tomcat-logs"
else
    echo "Network volume not detected. Logs will be stored in default location."
fi

# Start Tomcat in the background
${CATALINA_HOME}/bin/catalina.sh run &

# Start the RunPod handler
python3 /handler.py