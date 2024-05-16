# Use the official Jenkins LTS base image
FROM ubuntu

# Set the desired username 
ARG USERNAME=ubuntu

# Switch to root user temporarily
USER root


# RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \ 
# sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# Update packages and install OpenSSH server
# trunk-ignore(hadolint/DL3033)
RUN apt -y update && \
    apt -y install sudo openssh-server default-jre && \
    # apt -y install  && \
    apt clean all

# Generate host keys
RUN ssh-keygen -A
RUN chmod 644 /etc/ssh/sshd_config

# Create a user with the specified username and give sudo privileges
# RUN useradd -m -s /bin/bash $USERNAME && \
RUN echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/$USERNAME

# Set password for the user 'centos' (replace 'password' with your desired password)
RUN echo 'ubuntu:password' | chpasswd
RUN mkdir /home/$USERNAME/.ssh && chmod 700 /home/$USERNAME/.ssh
COPY ./ssh_pub_key/id_rsa.pub /home/$USERNAME/.ssh/authorized_keys
RUN chmod 600 /home/$USERNAME/.ssh/authorized_keys
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

# Create a dynamic motd script
RUN echo '#!/bin/bash' > /etc/update-motd.d/99-dynamic-motd \
    && echo 'echo "Welcome to Ubuntu $(lsb_release -sd)"' >> /etc/update-motd.d/99-dynamic-motd \
    && echo 'echo "Kernel Version: $(uname -r)"' >> /etc/update-motd.d/99-dynamic-motd \
    && chmod +x /etc/update-motd.d/99-dynamic-motd

# Set the user as the default user for the image
USER $USERNAME

#RUN  chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

# Set the working directory (optional)
WORKDIR /home/$USERNAME

#Create working dir for Jenkins
RUN mkdir -p /home/$USERNAME/jenkins_workdir

# # Expose the HTTP port
EXPOSE 22

RUN sudo mkdir -p /run/sshd
RUN sudo chmod 755 /run/sshd

CMD sudo /usr/sbin/sshd -D
