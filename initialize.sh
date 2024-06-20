#!/bin/bash

# Define the directory paths
jenkins_data_path="$(pwd)/jenkins_data"
docker_path="$(pwd)/docker"

# Create jenkins_data folder
mkdir -p "$jenkins_data_path"

# Create .ssh directory
mkdir -p "$jenkins_data_path/.ssh"

# Generate SSH key pair and save in .ssh directory
ssh-keygen -f "$jenkins_data_path/.ssh/id_rsa" -t rsa-sha2-512 -N ''

# Output success message
echo "SSH key pair generated and saved in $jenkins_data_path/.ssh directory."

# Create ssh_pub_key folder under all folders under docker
for folder in "$docker_path"/*/; do
    ssh_pub_key_folder="$folder/ssh_pub_key"
    mkdir -p "$ssh_pub_key_folder"
    sudo cp "$jenkins_data_path/.ssh/id_rsa.pub" "$ssh_pub_key_folder/id_rsa.pub"
done

# Output success message
echo "ssh_pub_key folder created under all folders under $docker_path."
