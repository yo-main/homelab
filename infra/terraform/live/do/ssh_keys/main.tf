module "ssh_key_local" {
  source = "../../../modules/do/ssh"
  name   = "local"
  path   = "~/.ssh/id_rsa.pub"
}

module "ssh_key_ansible" {
  source = "../../../modules/do/ssh"
  name   = "ansible"
  path   = "../../../../ansible/secrets/id_rsa.pub"
}
