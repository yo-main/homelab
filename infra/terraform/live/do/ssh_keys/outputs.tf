output "local_ssh_key_name" {
  value = module.ssh_key_local.name
}

output "local_ssh_key_id" {
  value = module.ssh_key_local.id
}

output "ansible_ssh_key_name" {
  value = module.ssh_key_ansible.name
}

output "ansible_ssh_key_id" {
  value = module.ssh_key_ansible.id
}
