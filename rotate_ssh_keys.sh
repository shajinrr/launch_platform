#!/bin/bash

jenkins_data_path="$(pwd)/jenkins_data"

# List all containers including stopped ones
containers=$(docker ps -aq)

for container in $containers; do
    # Check if the container is running CentOS
    if docker exec $container cat /etc/os-release | grep -q "CentOS"; then
        docker cp "$jenkins_data_path/.ssh/id_rsa.pub" $container:/tmp/id_rsa.pub
        docker exec $container bash -c 'mkdir -p /home/centos/.ssh && cat /tmp/id_rsa.pub > /home/centos/.ssh/authorized_keys && rm /tmp/id_rsa.pub'
        echo "SSH public key pushed to CentOS container $container"
    fi

    # Check if the container is running Ubuntu
    if docker exec $container cat /etc/os-release | grep -q "Ubuntu"; then
        docker cp "$jenkins_data_path/.ssh/id_rsa.pub" $container:/tmp/id_rsa.pub
        docker exec $container bash -c 'mkdir -p /home/ubuntu/.ssh && cat /tmp/id_rsa.pub > /home/ubuntu/.ssh/authorized_keys && rm /tmp/id_rsa.pub'
        echo "SSH public key pushed to Ubuntu container $container"
    fi
done

