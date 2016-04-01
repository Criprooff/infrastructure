variable "num_nodes" { }
variable "region" { }

variable "image" {
	default = "ubuntu-14-04-x64"
}
variable "size" {
	default = "1GB"
}
variable "ssh_keys" {
	default = ""
}

resource "digitalocean_droplet" "consul" {
  image = "${var.image}"
  name = "consul.${count.index+1}"
  region = "${var.region}"
  size = "${var.size}"
  ssh_keys = ["${split(",", var.ssh_keys)}"]

  provisioner "remote-exec" {
	connection {
	  user = "root"
	}

	inline = [
	  "mkdir /opt",
	  "mkdir /etc/consul.d",
	  "mkdir -p /opt/apps/consul/data"
	]
  }
  
  provisioner "file" {
	connection {
	  user = "root"
	}

	source = "modules/consul/files/config.json"
	destination = "/etc/consul.d/config.json"
  }
  
  provisioner "file" {
	connection {
	  user = "root"
	}

	source = "modules/consul/files/consul.conf"
	destination = "/etc/init/consul.conf"
  }

  provisioner "file" {
	connection {
	  user = "root"
	}

	source = "modules/consul/files/join_consul.sh"
	destination = "/opt/join_consul.sh"
  }


  provisioner "remote-exec" {
	connection {
	  user = "root"
	}

	inline = [
	  "apt-get update",
	  "apt-get install -y unzip curl git",
	  "cd /opt",
	  "curl -sO https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip",
	  "unzip consul_0.6.4_linux_amd64.zip",
	  "rm /opt/consul_0.6.4_linux_amd64.zip",
	  "service consul start"
	]
  }

  count = "${var.num_nodes}"
}

resource "digitalocean_record" "primary_consul_node" {
  depends_on = [ "digitalocean_droplet.consul" ]
  
  domain = "canaries.tech"
  type = "A"
  name = "consul"
  value = "${digitalocean_droplet.consul.0.ipv4_address}"
}

resource "null_resource" "init_consul" {
  depends_on = [ "digitalocean_droplet.consul" ]

  provisioner "remote-exec" {
	connection {
	  user = "root"
	  host = "${digitalocean_droplet.consul.0.ipv4_address}"
	}

	inline = [
	  "bash /opt/join_consul.sh ${join(" ", digitalocean_droplet.consul.*.ipv4_address)}"
	]
  }
}
