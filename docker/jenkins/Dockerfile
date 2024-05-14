# Use the official Jenkins LTS base image
FROM jenkins/jenkins:latest

USER root

RUN apt-get update && apt-get -yf install apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      plocate \
      net-tools \
      vim \
      wget \
      gnupg \
      software-properties-common \
      docker.io \
      ansible && apt-get clean \
      && rm -rf /var/lib/apt/lists/*
# RUN apt-get install -y systemctl

# #Install Docker Compose
# RUN curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose



#Terraform Repo
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list


#trivy Repo
RUN wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | tee /usr/share/keyrings/trivy.gpg > /dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | tee -a /etc/apt/sources.list.d/trivy.list



### Run apt update and install  Docker, Terraform and Trivy
RUN apt update -y 
RUN apt install -yf terraform  packer

#Install kubectl
RUN curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
RUN  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

#Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip 
RUN ./aws/install

#Download plugins.txt from internet
RUN curl -fsSL https://raw.githubusercontent.com/faudeltn/Jenkins/master/build/centos/plugins.txt -o /usr/share/jenkins/ref/plugins.txt \
&& echo "sonar" >> /usr/share/jenkins/ref/plugins.txt && echo  "configuration-as-code" >> /usr/share/jenkins/ref/plugins.txt

#/usr/share/jenkins/ref/plugins.txt

# Install recommended plugins listed in plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt


#Add the Job automatically during Launch
RUN mkdir -p /var/jenkins_home/jobs/freestyle_test
#COPY jobs/freestyle_test/config.xml /var/jenkins_home/jobs/freestyle_test/config.xml
ADD jobs/freestyle_test/config.xml /var/jenkins_home/jobs/freestyle_test/config.xml


#id_rsa.pub file will be saved at /root/.ssh/
#RUN ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''

# Skip the initial setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

#Update the username and password
ENV JENKINS_USER admin
ENV JENKINS_PASS ThisIs@StrongP@ssword



# Jenkins runs all grovy files from init.groovy.d dir
# use this for creating default admin user
# Copy the Groovy script
COPY 10-sleep.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY 20-default-user.groovy /usr/share/jenkins/ref/init.groovy.d/



# Set ownership of Jenkins home directory
RUN chown -R jenkins:jenkins /var/jenkins_home



# Set Jenkins as the user
USER jenkins

# Expose the HTTP port
EXPOSE 8080

# Expose the agent port
EXPOSE 50000


