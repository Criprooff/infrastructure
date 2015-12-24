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

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "serf1" {
  image = "${var.droplet_image}"
  name = "serf-1"
  region = "${var.droplet_region}"
  size = "${var.droplet_size}"
  ssh_keys = ["${var.ssh_key_id}"]

  provisioner "file" {
	connection {
	  user = "root"
	}

	source = "files/serf.conf"
	destination = "/etc/init/serf.conf"
  }

  provisioner "remote-exec" {
	connection {
	  user = "root"
	}

	inline = [
	  "apt-get update",
	  "apt-get install -y unzip curl",
	  "cd /opt",
	  "curl -sO https://releases.hashicorp.com/serf/0.7.0/serf_0.7.0_linux_amd64.zip",
	  "unzip serf_0.7.0_linux_amd64.zip",
	  "rm /opt/serf_0.7.0_linux_amd64.zip",
	  "service serf start"
	]
  }
}

resource "digitalocean_droplet" "serf2" {
  image = "${var.droplet_image}"
  name = "serf-2"
  region = "${var.droplet_region}"
  size = "${var.droplet_size}"
  ssh_keys = ["${var.ssh_key_id}"]

  provisioner "file" {
	connection {
	  user = "root"
	}

	source = "files/serf.conf"
	destination = "/etc/init/serf.conf"
  }

  provisioner "remote-exec" {
	connection {
	  user = "root"
	}

	inline = [
	  "apt-get update",
	  "apt-get install -y unzip curl",
	  "cd /opt",
	  "curl -sO https://releases.hashicorp.com/serf/0.7.0/serf_0.7.0_linux_amd64.zip",
	  "unzip serf_0.7.0_linux_amd64.zip",
	  "rm /opt/serf_0.7.0_linux_amd64.zip",
	  "service serf start"
	]
  }

}

resource "digitalocean_droplet" "serf3" {
  image = "${var.droplet_image}"
  name = "serf-3"
  region = "${var.droplet_region}"
  size = "${var.droplet_size}"
  ssh_keys = ["${var.ssh_key_id}"]

  provisioner "file" {
	connection {
	  user = "root"
	}

	source = "files/serf.conf"
	destination = "/etc/init/serf.conf"
  }

  provisioner "remote-exec" {
	connection {
	  user = "root"
	}

	inline = [
	  "apt-get update",
	  "apt-get install -y unzip curl",
	  "cd /opt",
	  "curl -sO https://releases.hashicorp.com/serf/0.7.0/serf_0.7.0_linux_amd64.zip",
	  "unzip serf_0.7.0_linux_amd64.zip",
	  "rm /opt/serf_0.7.0_linux_amd64.zip",
	  "service serf start"
	]
  }

}

resource "digitalocean_droplet" "serf4" {
  image = "${var.droplet_image}"
  name = "serf-4"
  region = "${var.droplet_region}"
  size = "${var.droplet_size}"
  ssh_keys = ["${var.ssh_key_id}"]

  provisioner "file" {
	connection {
	  user = "root"
	}

	source = "files/serf.conf"
	destination = "/etc/init/serf.conf"
  }

  provisioner "remote-exec" {
	connection {
	  user = "root"
	}

	inline = [
	  "apt-get update",
	  "apt-get install -y unzip curl",
	  "cd /opt",
	  "curl -sO https://releases.hashicorp.com/serf/0.7.0/serf_0.7.0_linux_amd64.zip",
	  "unzip serf_0.7.0_linux_amd64.zip",
	  "rm /opt/serf_0.7.0_linux_amd64.zip",
	  "service serf start"
	]
  }

}


output "ip_address_serf1" {
  value = "${digitalocean_droplet.serf1.ipv4_address}"
}

output "ip_address_serf2" {
  value = "${digitalocean_droplet.serf2.ipv4_address}"
}

output "ip_address_serf3" {
  value = "${digitalocean_droplet.serf3.ipv4_address}"
}

output "ip_address_serf4" {
  value = "${digitalocean_droplet.serf4.ipv4_address}"
}
