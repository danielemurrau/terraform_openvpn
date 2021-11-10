provider "aws" {
  profile = "default"
  region  = "${var.aws_region}"
}

provider "random" {}

resource "random_pet" "name" {}


resource "aws_instance" "OpenVPN" {
  ami           = "ami-0c1fea851a691f508"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = [aws_security_group.OpenVPN-sg.id]

  tags = {
    Name = random_pet.name.id
  }
}

resource "aws_eip" "vpn_access_server" {
  instance = "${aws_instance.OpenVPN.id}"
  vpc = true
}

resource "aws_security_group" "OpenVPN-sg" {
  name = "${random_pet.name.id}-sg"
  description = "Security group for OpenVPN server"
  ingress {
    from_port   = 0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    protocol  = "tcp"
    from_port = 943
    to_port   = 943
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = "udp"
    from_port = 1194
    to_port   = 1194
    cidr_blocks = ["0.0.0.0/0"]
  }
#to remove after this apply
  ingress {
    protocol  = "tcp"
    from_port = 1194
    to_port   = 1194
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "null_resource" "openvpn_bootstrap" {
  connection {
    type        = "ssh"
    host        = aws_instance.OpenVPN.public_ip
    user        = var.ec2_username
    port        = "22"
    #private_key = file("${path.module}/${var.key_name}")
    private_key = "${file(var.private_key_path)}"
    agent       = false
  }

 provisioner "remote-exec" {
    on_failure = continue
    inline = [
      "sudo apt-get update -y",
      "sleep 3",
      "wget ${var.openvpn_install_script_location}",
      #"export APPROVE_IP=${aws_instance.OpenVPN.public_ip}",
      #"export IPV6_SUPPORT=n",
      #"export PORT_CHOICE=1" ,
      #"export PROTOCOL_CHOICE=1",
      #"export DNS=1",
      #"export COMPRESSION_ENABLED=n",
      #"export CUSTOMIZE_ENC=n",
      #"export CLIENT=snip",
      #"export PASS=1",
      #"export ENDPOINT=$(curl -4 ifconfig.co)",
      #"env",
      #"ip a",
      "chmod +x openvpn-install.sh",
      "sudo AUTO_INSTALL=y CLIENT=snip bash openvpn-install.sh",
      "exit"
   ]

}
}

