# Data Source for getting Amazon Linux AMI
data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

/************************instance*****************************************/

# Resource for master
resource "aws_instance" "opcuaSystem" {
  ami = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"

  tags = {
    Name = "${var.opcuaSystemName}"
  }
  vpc_security_group_ids = [aws_security_group.ingress-all-ssh-opcuaSystem.id, aws_security_group.ingress-all-opcuaPort-opcuaSystem.id]
  user_data = templatefile("${path.module}/opcuaSystem.tpl", {})
}

/************************SECURITY*****************************************/

resource "aws_security_group" "ingress-all-ssh-opcuaSystem"{
  name = "${var.opcuaSystemName}-allow-all-ssh-opcuaSystem"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress-all-opcuaPort-opcuaSystem"{
  name = "${var.opcuaSystemName}-allow-all-opcuaPort-opcuaSystem"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 4840
    to_port = 4840
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}