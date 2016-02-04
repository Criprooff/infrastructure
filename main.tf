provider "digitalocean" {
  token = "${var.do_token}"
}

module "serf" {
	source = "./modules/serf"
	region = "nyc3"
	num_nodes = 3
}

