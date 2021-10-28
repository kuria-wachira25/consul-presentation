
data "aws_ami" "amazon_linux_2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "instance" {
  count         = length(var.consul_clients)
  subnet_id     = element(var.vpc_subnets_ids, count.index%3)
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  key_name      = "demo-datacenter-ssh"
  iam_instance_profile = var.instance_profile_name

  tags = {
    Name                = "${var.consul_cluster_name}-client-node-${count.index}"
    Consul-Cluster-Name = var.consul_cluster_name
    Agent-Type          = "client"
    App-Name            = element(var.consul_clients, count.index)
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  count                = length(var.consul_clients)
  security_group_id    = "sg-0f9ddbc5a64114dd2"
  network_interface_id = element(aws_instance.instance.*.primary_network_interface_id,count.index)
}