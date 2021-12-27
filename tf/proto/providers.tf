terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}
#variable "pvt_key" {}

provider "digitalocean" {
  token = var.do_token
}

# TODO: generate this file, pull ssh key name from config
data "digitalocean_ssh_key" "roudy_ssh_pub" {
  name = "roudy_ssh_pub"
}
