#!/bin/bash

# Create jenkins_data folder in the current directory
mkdir -p jenkins_data

# Change directory to jenkins_data
cd jenkins_data || exit

# Create .ssh directory
mkdir -p .ssh

# Generate SSH key pair and save in .ssh directory
ssh-keygen -f .ssh/id_rsa -t rsa -N ''

# Output success message
echo "SSH key pair generated and saved in jenkins_data/.ssh directory."

