# Deploy-Java-Application-on-AWS-3-Tier-Architecture
This project focuses on deploying a scalable, highly available, and secure Java application using a 3-tier architecture on AWS. The architecture leverages AWS services such as EC2 for the compute layer, RDS for database management, and VPC for networking and security. This ensures robust availability and scalability, with the application being accessible to users via the public internet.

# Pre-Deployment Setup
  1. Nginx - For the web tier, serving as a reverse proxy.
  2. Apache Tomcat - For the application tier, running Java applications.
  3. Maven - For the build and dependency management tier.

## Global AMI (Amazon Machine Image)
Before creating custom AMIs for the different tiers, follow these steps to install essential tools and agents on the EC2 instances.
  - Install AWS CLI
  To interact with AWS services, install the AWS CLI:
  ```
  curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
  sudo installer -pkg AWSCLIV2.pkg -target /
  aws --version
  ```
  - Install CloudWatch Agent
  The CloudWatch agent is required to monitor EC2 instances:
  ```
  sudo yum install amazon-cloudwatch-agent
  sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start
  ```
  - Install AWS Systems Manager Agent
  The SSM agent allows for EC2 instance management:
  ```
  sudo yum install amazon-ssm-agent
  sudo systemctl start amazon-ssm-agent
  sudo systemctl enable amazon-ssm-agent
  ```
## Creating Golden AMIs
  ### 1. Nginx AMI
- Launch an EC2 instance and install Nginx:
  ```
  sudo amazon-linux-extras install nginx1.12
  sudo systemctl start nginx
  sudo systemctl enable nginx
  ```
- Create a custom CloudWatch metric for memory usage:
  ```
  #!/bin/bash
  while true; do
      memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
      aws cloudwatch put-metric-data --metric-name MemoryUsage --namespace Custom --value $memory_usage --dimensions InstanceId=$(curl http://169.254.169.254/latest/meta-data/instance-id)
      sleep 60
  done &
  ```
  ### 2. Apache Tomcat AMI
- Launch an EC2 instance and install Apache Tomcat:
  ```
  sudo amazon-linux-extras install java-openjdk11 -y
  wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.96/bin/apache-tomcat-9.0.96.tar.gz
  sudo tar -xvzf apache-tomcat-9.0.96.tar.gz -C /opt/
  sudo ln -s /opt/apache-tomcat-9.0.96/ /opt/tomcat
  sudo sh /opt/tomcat/bin/startup.sh
  ```
- Configure Tomcat as a systemd service:
  ```
  sudo nano /etc/systemd/system/tomcat.service
  ```
- Add the following content:
  ```
  [Unit]
  Description=Apache Tomcat Web Application Container
  After=network.target
  
  [Service]
  Type=forking
  
  Environment=JAVA_HOME=/usr/lib/jvm/jre
  Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
  Environment=CATALINA_HOME=/opt/tomcat
  Environment=CATALINA_BASE=/opt/tomcat
  Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
  Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'
  
  ExecStart=/opt/tomcat/bin/startup.sh
  ExecStop=/opt/tomcat/bin/shutdown.sh
  
  User=tomcat
  Group=tomcat
  UMask=0007
  RestartSec=10
  Restart=always
  
  [Install]
  WantedBy=multi-user.target
- Enable and start the service:
  ```
  sudo systemctl daemon-reload
  sudo systemctl start tomcat
  sudo systemctl enable tomcat
  ```
### 3. Maven AMI
- Install Maven, Git, and JDK on a new EC2 instance:
  ```
  sudo yum install git
  sudo amazon-linux-extras install java-openjdk11 -y
  wget https://mirrors.ocf.berkeley.edu/apache/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.tar.gz
  sudo tar -xvzf apache-maven-3.8.4-bin.tar.gz -C /opt/
  sudo ln -s /opt/apache-maven-3.8.4 /opt/maven
  ```
- Update the system PATH:
  ```
  echo "export M2_HOME=/opt/maven" | sudo tee -a /etc/profile.d/maven.sh
  echo "export PATH=\$M2_HOME/bin:\$PATH" | sudo tee -a /etc/profile.d/maven.sh
  source /etc/profile.d/maven.sh
  ```
- Verify Maven installation:
  ```
  mvn -version
  ```
