output "bastion-sg" {
  description = "bastion host sg"
  value       = aws_security_group.sg_bastion_server.id
}

output "bastion_eip" {
  description = "bastion host"
  value       = aws_eip.bastion_eip.public_ip
}

output "bastion_key" {
  description = "bastion key"
  value       = aws_key_pair.bastion_key.key_name
}

output "bastion_server_id" {
  description = "Instnce ID of the bastion server"
  value       = module.bastion_instance.id
}
