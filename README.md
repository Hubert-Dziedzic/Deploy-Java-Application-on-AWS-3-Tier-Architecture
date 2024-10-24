# Deploy-Java-Application-on-AWS-3-Tier-Architecture
This project focuses on deploying a scalable, highly available, and secure Java application using a 3-tier architecture on AWS. The architecture leverages AWS services such as EC2 for the compute layer, RDS for database management, and VPC for networking and security. This ensures robust availability and scalability, with the application being accessible to users via the public internet.

# Pre-Deployment Setup
  1. Nginx - For the web tier, serving as a reverse proxy.
  2. Apache Tomcat - For the application tier, running Java applications.
  3. Maven - For the build and dependency management tier.

## Global AMI (Amazon Machine Image)
Before creating custom AMIs for the different tiers, follow these steps to install essential tools and agents on the EC2 instances.
  ### 1. Install AWS CLI
  To interact with AWS services, install the AWS CLI:
  ```
  curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
  sudo installer -pkg AWSCLIV2.pkg -target /
  aws --version
  ```
  ### 2. Install CloudWatch Agent
  The CloudWatch agent is required to monitor EC2 instances:
  ```
  sudo yum install amazon-cloudwatch-agent
  sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start
  ```
  ### 3. Install AWS Systems Manager Agent
  The SSM agent allows for EC2 instance management:
  ```
  sudo yum install amazon-ssm-agent
  sudo systemctl start amazon-ssm-agent
  sudo systemctl enable amazon-ssm-agent
  ```
