# set environmental variables:
#    TF_VAR_do_token to Digitalocean token
#    TF_VAR_ssh_key_id to Digitalocean ssh key id to enable on droplet
#         - See DigitalOcean API
#    TF_VAR_repositories comma seperated list of repositories

variable "do_token" {}
variable "ssh_key_id" {}

variable "project" {
  default = "github.com/criprooff/crdt_server"
}

variable "droplet_size" {
  default = "4gb"
}
variable "droplet_region" {
  default = "nyc3"
}
variable "droplet_image" {
  default = "ubuntu-14-04-x64"
}

variable "repositories" {
  default = "github.com/criprooff/crdt_server"
}

variable "num_nodes" {
  default = 1
}
