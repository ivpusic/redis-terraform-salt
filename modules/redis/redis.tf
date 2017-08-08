variable "redis_cluster_prefix" { default = "Tf-Redis-Cluster" }
variable "ssh_key" {  }
variable "vpc_id" {  }
variable "subnet_id" {  }
variable "ips" { type = "map" }
variable "nodes_count" { default = 1 }
variable "salt_master_ip" {  }

resource "aws_security_group" "Redis_SG" {
  name        = "${var.redis_cluster_prefix}-SG"
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

resource "aws_instance" "Redis_EC2" {
  ami = "ami-a8d2d7ce"
  instance_type = "t2.micro"
  count = "${var.nodes_count}"
  key_name = "${var.ssh_key}"
  vpc_security_group_ids =["${aws_security_group.Redis_SG.id}"]
  private_ip = "${lookup(var.ips, count.index)}"
  subnet_id = "${var.subnet_id}"

  tags {
    Name = "${var.redis_cluster_prefix}"
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
  }

  provisioner "file" {
    source      = "${path.module}/salt-minion.sh"
    destination = "/tmp/salt-minion.sh"
  }

  provisioner "file" {
    source      = "${path.module}/grains"
    destination = "/tmp/grains"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/salt-minion.sh",
      "/tmp/salt-minion.sh ${var.salt_master_ip}",
    ]
  }
}

output "public_ips" {
  value = ["${aws_instance.Redis_EC2.*.public_ip}"]
}
