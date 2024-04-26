FROM httpd:latest

# Switch to root user temporarily
#USER root


#RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \ 
#sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# Update packages and install OpenSSH server
RUN apt -y update && \
    apt -y install openssh-server
#    apt -y install sudo && \
#    apt clean all
# Generate host keys
#RUN ssh-keygen -A
#RUN chmod 644 /etc/ssh/sshd_config
# Set the desired username
#ARG USERNAME=apache

# Create a user with the specified username and give sudo privileges
#RUN useradd -m -s /bin/bash $USERNAME && \
#    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/$USERNAME
# Set password for the user 'centos' (replace 'password' with your desired password)
#RUN echo 'apache:password' | chpasswd
#RUN mkdir /home/$USERNAME/.ssh && chmod 700 /home/$USERNAME/.ssh
#COPY ./keys/id_rsa.pub /home/$USERNAME/.ssh/authorized_keys
#RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
# Set the user as the default user for the image
#USER $USERNAME

#RUN  chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

# Set the working directory (optional)
#WORKDIR /home/$USERNAME

# Print a welcome message
#RUN echo "Welcome to the CentOS image with user '$USERNAME'!"

# Expose the HTTP port
#EXPOSE 22


COPY ./content/ /usr/local/apache2/htdocs/
