variable "num_nodes" { }
variable "region" { }

variable "image" {
	default = "ubuntu-x86_64"
}
variable "size" {
	default = "1GB"
}
variable "ssh_keys" {
	default = ""
}

resource "digitalocean_droplet" "serf" {
  image = "${var.image}"
  name = "serf.${count.index+1}"
  region = "${var.region}"
  size = "${var.size}"
  ssh_keys = ["${var.ssh_keys}"]

  provisioner "file" {
	connection {
	  user = "root"
	}

	source = "files/serf.conf"
	destination = "/etc/init/serf.conf"
  }

  provisioner "file" {
	connection {
	  user = "root"
	}

	source = "files/join_serf.sh"
	destination = "/opt/join_serf.sh"
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


resource "null_resource" "init_serf" {
  depends_on = [ "digitalocean_droplet.serf" ]

  provisioner "remote-exec" {
	connection {
	  user = "root"
	  host = "${digitalocean_droplet.serf.0.ipv4_address}"
	}

	inline = [
	  "bash /opt/join_serf.sh ${join(" ", digitalocean_droplet.serf.*.ipv4_address)}"
	]
  }
}

