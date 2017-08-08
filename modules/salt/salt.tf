variable "salt_cluster_prefix" { default = "Tf-Salt" }
variable "ssh_key" {  }
variable "vpc_id" {  }
variable "subnet_id" {  }
variable "ip" {  }

resource "aws_security_group" "Salt_SG" {
  name        = "${var.salt_cluster_prefix}-SG"
  description = "Allow all inbound traffic"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Salt_EC2" {
  ami = "ami-a8d2d7ce"
  instance_type = "t2.micro"
  count = 1
  key_name = "${var.ssh_key}"
  vpc_security_group_ids =["${aws_security_group.Salt_SG.id}"]
  private_ip = "${var.ip}"
  subnet_id = "${var.subnet_id}"

  tags {
    Name = "${var.salt_cluster_prefix}"
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
  }

  provisioner "file" {
    source      = "${path.module}/salt-master.sh"
    destination = "/tmp/salt-master.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/salt-master.sh",
      "/tmp/salt-master.sh",
    ]
  }
}

output "public_ip" {
  value = "${aws_instance.Salt_EC2.public_ip}"
}

output "private_ip" {
  value = "${aws_instance.Salt_EC2.private_ip}"
}
