provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "serf" {
  image = "${var.droplet_image}"
  name = "serf.${count.index+1}"
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

  count = "${var.num_nodes}"
}
