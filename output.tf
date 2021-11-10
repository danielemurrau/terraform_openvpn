output "instance_name" {
  value       = random_pet.name.id
  description = "The name."
}

output "EIP_vpn_access_server_dns" {
  value = "${aws_eip.vpn_access_server.public_dns}"
}

output "IP_domain-name" {
  value = aws_instance.OpenVPN.public_dns
}
