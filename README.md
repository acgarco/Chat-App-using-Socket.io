# Chat-App-using-Socket.io
A simple chat app using socket.io
  
See it in action - [Kunal Chat App](https://kunal-chat-app.herokuapp.com)


This README provides step-by-step instructions to set up the infrastructure using Terraform, AWS and Ansible.

Prerequisites
Before proceeding with the setup, I ensured have the following prerequisites in place:
- Terraform
- Ansible
- An AWS account with the necessary permissions to create VPCs, EC2 instances, load balancers, etc.
- AWS CLI configured with valid access and secret keys and an IAM role assigned with the appropriate permissions.

STEP 1: Networking Setup
In this step, I created a VPC with 2 public subnets in different availability zones.
I configured the region, CIDR blocks, and availability zones.

To test this step, in console I used the commands:
- terraform init = to initialize the Terraform configuration
- terraform plan = to review the changes that Terraform will make
- terraform apply = to create the VPC and subnets.


STEP 2: EC2 Instance
In this step, I created 2 EC2 instances and associated them with the previously created VPC and subnets.

Configuration include  set filds such AMI, instance type, key pair, and subnet IDs.
To create the key pair, I used the command "ssh-keygen -t rsa -b 4096" in console

To test this step, in console I used the commands:
- terraform plan = to review the changes
- terraform apply = to create the EC2 instances.

STEP 3: Application Load Balancer Setup
In this step, I tried to create an Application Load Balancer (ALB) to route traffic to the EC2 instances.
Configuration includes  the ALB name, load balancer type, and subnets. However, I couldn't tried this step due to an error, so this part is commented in the main.tf

STEP 4: Node.js and Application Configuration
In this step, I installed Node.js on the EC2 instances and configure the application using Ansible.

The file inventory.ini has the actual public IP addresses and SSH key paths for the EC2 instances.
Review and customize the install_app.yml Ansible playbook if needed for additional application configuration.
Run ansible-playbook -i inventory.ini install_app.yml to execute the playbook and install Node.js on the EC2 instances.
Step 5: Additional Steps and Considerations
Provide any additional instructions or considerations that are specific to your application and infrastructure setup.
Include any post-deployment steps or ongoing maintenance instructions if applicable.
Document any variables or configuration options that need to be adjusted or customized for different environments.