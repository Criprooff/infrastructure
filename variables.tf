# set environmental variables:
#    TF_VAR_do_token to Digitalocean token
#    TF_VAR_ssh_key_id to Digitalocean ssh key id to enable on droplet
#         - See DigitalOcean API

variable "do_token" {}
variable "ssh_key_id" {}
variable "droplet_size" {
  default = "4gb"
}
variable "droplet_region" {
  default = "nyc3"
}
variable "droplet_image" {
  default = "ubuntu-14-04-x64"
}
variable "num_nodes" {
  default = 3
}
