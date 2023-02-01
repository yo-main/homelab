data "terraform_remote_state" "ssh_keys" {
  backend = "local"

  config = {
    path = "../ssh_keys/terraform.tfstate"
  }
}

module "db_droplet" {
  source = "../../../modules/do/droplet"

  image  = "debian-11-x64"
  name   = "database-droplet"
  region = "FRA1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    data.terraform_remote_state.ssh_keys.outputs.local_ssh_key_id,
    data.terraform_remote_state.ssh_keys.outputs.ansible_ssh_key_id,
  ]
  volumes = [
    {
      name       = "database-volume"
      size       = 5
      filesystem = "ext4"
    }
  ]
}
