# outputs.tf
output "jenkins_instance_ips" {
  description = "Public IP addresses of Jenkins instances"
  value = {
    for k, instance in module.ec2_instance : k => instance.public_ip
  }
}

output "jenkins_instance_ids" {
  description = "Instance IDs of Jenkins instances"
  value = {
    for k, instance in module.ec2_instance : k => instance.id
  }
}

output "jenkins_urls" {
  description = "Jenkins access URLs"
  value = {
    for k, instance in module.ec2_instance : k => "http://${instance.public_ip}:8080"
  }
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "security_group_id" {
  description = "Security Group ID"
  value       = module.sg.security_group_id
}