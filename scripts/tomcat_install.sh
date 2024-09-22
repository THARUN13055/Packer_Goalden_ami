#!/bin/bash

# Install required packages
sudo apt-get install unzip -y
sudo apt-get install wget -y
sudo apt-get install openjdk-17-jdk -y

# Installing Tomcat
TOMCAT_VERSION=9.0.95
TOMCAT_DIR="/opt/tomcat"

# Download Tomcat
wget https://dlcdn.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.zip

# Check if the download was successful
if [ $? -ne 0 ]; then
    echo "Error downloading Tomcat. Exiting."
    exit 1
fi

# Unzip Tomcat
unzip apache-tomcat-${TOMCAT_VERSION}.zip

# Create Tomcat directory if it doesn't exist
sudo mkdir -p ${TOMCAT_DIR}

# Move the extracted Tomcat to /opt/tomcat
sudo mv apache-tomcat-${TOMCAT_VERSION}/* ${TOMCAT_DIR}

# Make sure the Tomcat scripts are executable
if [ -d "${TOMCAT_DIR}/bin" ]; then
    sudo chmod +x ${TOMCAT_DIR}/bin/*.sh
else
    echo "Tomcat installation failed: ${TOMCAT_DIR}/bin does not exist."
    exit 1
fi

# Modify Tomcat's server.xml to change the port to 8086
if [ -f "${TOMCAT_DIR}/conf/server.xml" ]; then
    sudo sed -i 's/8080/8086/g' ${TOMCAT_DIR}/conf/server.xml
else
    echo "server.xml not found! Exiting."
    exit 1
fi

echo "Tomcat installed and configured successfully."

# Move the WAR file to the Tomcat webapps directory
WAR_FILE="/tmp/target/paynpro_java_test.war"
if [ -f "${WAR_FILE}" ]; then
    sudo mv ${WAR_FILE} ${TOMCAT_DIR}/webapps/
else
    echo "WAR file not found at ${WAR_FILE}. Exiting."
    exit 1
fi

echo "WAR file moved to Tomcat webapps directory."
