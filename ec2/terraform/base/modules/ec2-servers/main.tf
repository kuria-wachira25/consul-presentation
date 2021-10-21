
data "aws_ami" "amazon_linux_2" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "instance" {
  count         = var.consul_cluster_server_size
  subnet_id     = element(var.vpc_subnets_ids,count.index)
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  key_name      = "demo-datacenter-ssh"

  tags = {
    Name = "${var.consul_cluster_name}-server-node-${count.index}"
    Consul-Cluster-Name = var.consul_cluster_name
  }
}