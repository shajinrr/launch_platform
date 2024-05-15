# Use the official Jenkins LTS base image
FROM centos:8.3.2011

# Switch to root user temporarily
USER root


RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \ 
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# Update packages and install OpenSSH server
# trunk-ignore(hadolint/DL3033)
RUN yum -y update && \
    yum -y install openssh-server && yum install java-11-openjdk && \
    yum -y install sudo && \
    yum clean all
# # Install OpenJDK (you can choose a different version if needed)
# RUN apt-get update && \
#     apt-get install -y openjdk-11-jdk && \
#     apt-get clean

# Set JAVA_HOME environment variable
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

# Generate host keys
RUN ssh-keygen -A
RUN chmod 644 /etc/ssh/sshd_config
# Set the desired username
ARG USERNAME=centos

# Create a user with the specified username and give sudo privileges
RUN useradd -m -s /bin/bash $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/$USERNAME
# Set password for the user 'centos' (replace 'password' with your desired password)
RUN echo 'centos:password' | chpasswd
RUN mkdir /home/$USERNAME/.ssh && chmod 700 /home/$USERNAME/.ssh
COPY ./ssh_pub_key/id_rsa.pub /home/$USERNAME/.ssh/authorized_keys
RUN chmod 600 /home/$USERNAME/.ssh/authorized_keys
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
# Set the user as the default user for the image
USER $USERNAME

#RUN  chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

# Set the working directory (optional)
WORKDIR /home/$USERNAME

# Print a welcome message
RUN echo "Welcome to the CentOS image with user '$USERNAME'!"

# # Expose the HTTP port
EXPOSE 22

CMD sudo /usr/sbin/sshd -D
