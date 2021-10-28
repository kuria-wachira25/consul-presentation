output "server_instance_private_ips" {
  value = module.ec2_servers.instance_private_ips
}

output "server_instance_public_ips" {
  value = module.ec2_servers.instance_public_ips
}