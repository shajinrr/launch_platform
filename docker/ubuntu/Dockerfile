# Use the official Ubuntu base image
FROM ubuntu:18.04

# Set the desired username 
ARG USERNAME=ubuntu

# Switch to root user temporarily
USER root

# Update packages, install OpenSSH server and Java, and clean up
RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo openssh-server default-jre && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Generate host keys
RUN ssh-keygen -A && \
    chmod 644 /etc/ssh/sshd_config

# Create a user with the specified username and give sudo privileges
RUN echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    useradd -m -s /bin/bash $USERNAME && \
    echo "$USERNAME:password" | chpasswd && \
    mkdir -p /home/$USERNAME/.ssh && \
    chmod 700 /home/$USERNAME/.ssh && \
    chown $USERNAME:$USERNAME /home/$USERNAME/.ssh

# Copy the public key into the authorized_keys file
COPY ./ssh_pub_key/id_rsa.pub /home/$USERNAME/.ssh/authorized_keys
RUN chmod 600 /home/$USERNAME/.ssh/authorized_keys && \
    chown $USERNAME:$USERNAME /home/$USERNAME/.ssh/authorized_keys

# Create a dynamic motd script
RUN echo '#!/bin/bash' > /etc/update-motd.d/99-dynamic-motd && \
    echo 'echo "Welcome to Ubuntu $(lsb_release -sd)"' >> /etc/update-motd.d/99-dynamic-motd && \
    echo 'echo "Kernel Version: $(uname -r)"' >> /etc/update-motd.d/99-dynamic-motd && \
    chmod +x /etc/update-motd.d/99-dynamic-motd

# Set the working directory (optional) and create working dir for Jenkins
RUN mkdir -p /home/$USERNAME/jenkins_workdir && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/jenkins_workdir && \
    mkdir -p /run/sshd && \
    chmod 755 /run/sshd

# Expose the SSH port
EXPOSE 22

# Set the user as the default user for the image
USER $USERNAME

# Start the SSH service
CMD sudo /usr/sbin/sshd -D
