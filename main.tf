provider "digitalocean" {
  token = "${var.do_token}"
}

module "consul" {
  source = "./modules/consul"
  region = "nyc3"
  num_nodes = 3
  ssh_keys = "${var.ssh_key_id}"
}

resource "terraform_remote_state" "state" {
  backend = "consul"
  config {
	path = "criprooff/infrastructure"
	address = "104.236.74.155:8500"
  }
}

module "serf" {
  source = "./modules/serf"
  region = "nyc3"
  num_nodes = "${var.num_nodes}"
  ssh_keys = "${var.ssh_key_id}"
  repositories = "${var.repositories}"
}
