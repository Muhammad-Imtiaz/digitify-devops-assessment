# BASTION HOST OBJECT

output "bastion-sg" {
  description = "bastion host sg"
  value       = module.bastion.bastion-sg # 
}

output "bastion_elastic_ip" {
  description = "Bastion Elastic IP"
  value       = module.bastion.bastion_eip
}

output "bastion_key" {
  description = "bastion key"
  value       = module.bastion.bastion_key
}

output "bastion_server_id" {
  description = "bastion server id"
  value       = module.bastion.bastion_server_id
}
