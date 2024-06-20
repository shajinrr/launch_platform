# Use the official CentOS 7 base image
FROM centos:7

# Set the desired username
ARG USERNAME=centos

# Switch to root user temporarily
USER root

# Update packages, install OpenSSH server and OpenJDK, and clean up
RUN yum -y update && \
    yum -y install sudo openssh-server java-11-openjdk && \
    yum clean all && \
    rm -rf /var/cache/yum /tmp/* /var/tmp/*

# Set JAVA_HOME environment variable
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk

# Generate host keys and configure SSH
RUN ssh-keygen -A && \
    chmod 644 /etc/ssh/sshd_config

# Create a user with the specified username and give sudo privileges
RUN useradd -m -s /bin/bash $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    echo 'centos:password' | chpasswd && \
    mkdir -p /home/$USERNAME/.ssh && \
    chmod 700 /home/$USERNAME/.ssh

# Copy the public key into the authorized_keys file
COPY ./ssh_pub_key/id_rsa.pub /home/$USERNAME/.ssh/authorized_keys
RUN chmod 600 /home/$USERNAME/.ssh/authorized_keys && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

# Create a dynamic motd script
RUN echo '#!/bin/bash' > /etc/profile.d/dynamic_motd_centos.sh && \
    echo 'echo "Welcome to CentOS $(cat /etc/centos-release)"' >> /etc/profile.d/dynamic_motd_centos.sh && \
    echo 'echo "Kernel Version: $(uname -r)"' >> /etc/profile.d/dynamic_motd_centos.sh && \
    chmod +x /etc/profile.d/dynamic_motd_centos.sh

# Create working directory for Jenkins and set permissions
RUN mkdir -p /home/$USERNAME/jenkins_workdir && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/jenkins_workdir

# Prepare SSH daemon directory
RUN mkdir -p /run/sshd && \
    chmod 755 /run/sshd

# Set the user as the default user for the image
USER $USERNAME

# Set the working directory (optional)
WORKDIR /home/$USERNAME

# Expose the SSH port
EXPOSE 22

# Start the SSH service
CMD ["sudo", "/usr/sbin/sshd", "-D"]
