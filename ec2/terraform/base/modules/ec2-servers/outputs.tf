output "instance_private_ips" {
  value = aws_instance.instance.*.private_ip
}