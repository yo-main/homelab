resource "digitalocean_droplet" "main" {
  image    = var.image
  name     = var.name
  region   = var.region
  size     = var.size
  ssh_keys = var.ssh_keys
}

resource "digitalocean_volume" "main" {
  count = length(var.volumes)

  region                  = digitalocean_droplet.main.region
  name                    = var.volumes[count.index].name
  size                    = var.volumes[count.index].size
  initial_filesystem_type = var.volumes[count.index].filesystem
}

resource "digitalocean_volume_attachment" "main" {
  count = length(digitalocean_volume.main)

  droplet_id = digitalocean_droplet.main.id
  volume_id  = digitalocean_volume.main[count.index].id
}

resource "digitalocean_reserved_ip" "main" {
  droplet_id = digitalocean_droplet.main.id
  region     = digitalocean_droplet.main.region
}

resource "digitalocean_firewall" "main" {
  count = length(var.allowed_ips) > 0 ? 1 : 0

  name = "firewall-${var.name}"
  droplet_ids = [digitalocean_droplet.main.id]

  inbound_rule {
    protocol = "tcp"
    port_range = "1-65535"
    source_addresses = var.allowed_ips
  }

  inbound_rule {
    protocol = "udp"
    port_range = "1-65535"
    source_addresses = var.allowed_ips
  }
}