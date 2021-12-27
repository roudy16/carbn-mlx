resource "digitalocean_droplet" "proto-vmhost-0" {
  image  = "ubuntu-21-10-x64"
  name   = "proto-vmhost-0"
  region = "nyc3"
  size   = "s-1vcpu-1gb"

  # TODO: generate this file, pull ssh key name from config
  ssh_keys = [
    data.digitalocean_ssh_key.roudy_ssh_pub.id
  ]
}
