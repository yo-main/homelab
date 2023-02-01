resource "digitalocean_ssh_key" "main" {
  name       = var.name
  public_key = file(var.path)
}
