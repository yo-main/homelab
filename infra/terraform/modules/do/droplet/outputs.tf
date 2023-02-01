output "id" {
  value = digitalocean_droplet.main.id
}

output "urn" {
  value = digitalocean_droplet.main.urn
}

output "ipv4" {
  value = digitalocean_reserved_ip.main.ip_address
}
