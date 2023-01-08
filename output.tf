output "cicd-instance-eni" {
  value = aws_instance.self[0].primary_network_interface_id
}

output "docker-compose-public-ip" {
  value = aws_instance.self[0].public_ip
}
