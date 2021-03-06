
data "aws_ami" "amazon_linux_2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "instance" {
  count         = var.consul_cluster_server_size
  subnet_id     = element(var.vpc_subnets_ids, count.index%3)
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  key_name      = "demo-datacenter-ssh"
  iam_instance_profile = var.instance_profile_name

  tags = {
    Name                = "${var.consul_cluster_name}-server-node-${count.index}"
    Consul-Cluster-Name = var.consul_cluster_name
    Agent-Type          = "server"
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  count                = var.consul_cluster_server_size
  security_group_id    = "sg-08880ee822ac1b7ee"
  network_interface_id = element(aws_instance.instance.*.primary_network_interface_id,count.index)
}