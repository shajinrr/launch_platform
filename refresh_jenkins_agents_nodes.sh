#!/bin/bash

# Base directory for Jenkins node configurations
BASE_DIR="$(pwd)/jenkins_data/nodes"

# Ensure the base directory exists
mkdir -p "$BASE_DIR"

# Get Docker containers with names starting with prod, dev, or stge
containers=$(docker ps --format '{{.Names}} {{.ID}}' | grep -E '^(prod|dev|stge)')

# Loop through each container
while read -r name id; do
  # Get the IP address of the container
  ip=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$id")

  # Create a directory for the node configuration
  node_dir="$BASE_DIR/$name"
  mkdir -p "$node_dir"

  # Create the config.xml file
  cat > "$node_dir/config.xml" <<EOL
<?xml version='1.1' encoding='UTF-8'?>
<slave>
  <name>$name</name>
  <description></description>
  <remoteFS>/home/centos/jenkins_workdir</remoteFS>
  <numExecutors>1</numExecutors>
  <mode>EXCLUSIVE</mode>
  <retentionStrategy class="hudson.slaves.RetentionStrategy\$Always"/>
  <launcher class="hudson.plugins.sshslaves.SSHLauncher" plugin="ssh-slaves@2.968.v6f8823c91de4">
    <host>$ip</host>
    <port>22</port>
    <credentialsId>ssh-key-master</credentialsId>
    <launchTimeoutSeconds>60</launchTimeoutSeconds>
    <maxNumRetries>10</maxNumRetries>
    <retryWaitTime>15</retryWaitTime>
    <sshHostKeyVerificationStrategy class="hudson.plugins.sshslaves.verifiers.NonVerifyingKeyVerificationStrategy"/>
    <tcpNoDelay>true</tcpNoDelay>
  </launcher>
  <label></label>
  <nodeProperties/>
</slave>
EOL

done <<< "$containers"

echo "Node configuration files created successfully."

