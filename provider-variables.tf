variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS Profile for Terraform"
  default     = "default"
}

variable "ec2_ami" {
  type = string
  description = "Define ami ID for the ec2"
  default = "ami-0b0af3577fe5e3532" #AMI ID RHEL-8.4.0_HVM-20210504-x86_64-2-Hourly2-GP2
}

variable "ec2_instance_type" {
  type = string
  description = "EC2 Instance type"
  default = "t3.large" # ~60 USD p/month
}

variable "ec2_key_name" {
  type = string
  description = "Key used to connect to the instance"
  default = "Test-Key" #Your Key
}
