# terraform

Install Terraform: Download and install the Terraform binary appropriate for your operating system from the official Terraform website.

Create a directory for your Terraform configuration files: Create a new directory on your computer and navigate to it in your terminal or command prompt.

Initialize Terraform: Run the terraform init command in your terminal or command prompt to initialize your Terraform project.

Write your Terraform configuration files: Create a new file with a .tf extension and write the Terraform code to create an EC2 instance.

Here is an example Terraform configuration file that creates an EC2 instance:

arduino
Copy code
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my_key_pair"
  subnet_id     = "subnet-abc12345"
}
This code creates an EC2 instance using the ami-0c55b159cbfafe1f0 Amazon Machine Image (AMI) in the us-east-1 region,
 with an instance type of t2.micro. The key_name parameter specifies the name of an existing EC2 key pair that can be
 used to log in to the instance, and the subnet_id parameter specifies the ID of an existing VPC subnet in which the instance will be launched.

Run terraform apply: Run the terraform apply command in your terminal or command prompt to apply your Terraform 
configuration and create the EC2 instance. Terraform will prompt you to confirm that you want to create the instance before proceeding.
Once the terraform apply command has finished running, you should be able to log in to your new EC2 instance 
using the key pair you specified in the Terraform configuration file.
