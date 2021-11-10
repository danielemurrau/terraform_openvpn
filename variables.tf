variable "aws_region" {
  description = "AWS region"
  default = "eu-central-1"
}

variable "ami_id" {
  description = "ID of the AMI to provision. Default is Ubuntu 14.04 Base Image"
  default = "ami-0c1fea851a691f508"
}

variable "instance_type" {
  description = "type of EC2 instance to provision."
  default = "t2.nano"
}

variable "ec2_username" {
  description = "EC2 username."
  default = "ubuntu"
}

variable "key_name" {
  description = "key pair"
  default = "dmitp"
}

variable "private_key_path" {
  description = "key_path"
  default = "../dmitp-key/dmitp.pem"
}

variable "name" {
  description = "name to pass to Name tag"
  default = "Provisioned by Terraform"
}

variable "openvpn_install_script_location" {
  description = "git url to download openvpn install script"
  default = "https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh"
}
