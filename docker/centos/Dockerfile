# Use the official Jenkins LTS base image
FROM centos:7

# Set the desired username
ARG USERNAME=centos

# Switch to root user temporarily
USER root


# RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \ 
# sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# Update packages and install OpenSSH server
# trunk-ignore(hadolint/DL3033)
RUN yum -y update && \
    yum -y install sudo openssh-server java-11-openjdk && \
    yum clean all
# # Install OpenJDK (you can choose a different version if needed)
# RUN apt-get update && \
#     apt-get install -y openjdk-11-jdk && \
#     apt-get clean

# Set JAVA_HOME environment variable
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

# Generate host keys
RUN sudo ssh-keygen -A
RUN chmod 644 /etc/ssh/sshd_config



# Create a user with the specified username and give sudo privileges
RUN useradd -m -s /bin/bash $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/$USERNAME

    # Set password for the user 'centos' (replace 'password' with your desired password)
RUN echo 'centos:password' | chpasswd
RUN mkdir /home/$USERNAME/.ssh && chmod 700 /home/$USERNAME/.ssh
COPY ./ssh_pub_key/id_rsa.pub /home/$USERNAME/.ssh/authorized_keys
RUN chmod 600 /home/$USERNAME/.ssh/authorized_keys
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

# Create a dynamic motd script
RUN echo '#!/bin/bash' > /etc/profile.d/dynamic_motd_centos.sh \
    && echo 'echo "Welcome to CentOS $(cat /etc/centos-release)"' >> /etc/profile.d/dynamic_motd_centos.sh \
    && echo 'echo "Kernel Version: $(uname -r)"' >> /etc/profile.d/dynamic_motd_centos.sh \
    && chmod +x /etc/profile.d/dynamic_motd_centos.sh

# Set the user as the default user for the image
USER $USERNAME



# Set the working directory (optional)
WORKDIR /home/$USERNAME

#Create working dir for Jenkins
RUN mkdir -p /home/$USERNAME/jenkins_workdir

# # Expose the HTTP port
EXPOSE 22

# RUN sudo mkdir -p /run/sshd
# RUN sudo chmod 755 /run/sshd
CMD [ "sudo", "/usr/sbin/sshd", "-D" ]
