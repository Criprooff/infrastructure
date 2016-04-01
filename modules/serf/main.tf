variable "num_nodes" {
  default = 1
}

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

variable "repositories" { }

resource "digitalocean_droplet" "serf" {
  image = "${var.image}"
  name = "serf.${count.index+1}"
  region = "${var.region}"
  size = "${var.size}"
  ssh_keys = ["${split(",", var.ssh_keys)}"]

  provisioner "remote-exec" {
	connection {
	  user = "root"
	}

	inline = [
	  "mkdir /opt"
	]
  }
  
  provisioner "file" {
	connection {
	  user = "root"
	}

	source = "modules/serf/files/serf.conf"
	destination = "/etc/init/serf.conf"
  }

  provisioner "file" {
	connection {
	  user = "root"
	}

	source = "modules/serf/files/join_serf.sh"
	destination = "/opt/join_serf.sh"
  }

  provisioner "remote-exec" {
	connection {
	  user = "root"
	}

	inline = [
	  "apt-get update",
	  "apt-get install -y unzip curl git",
	  "cd /opt",
	  "curl -sO https://releases.hashicorp.com/serf/0.7.0/serf_0.7.0_linux_amd64.zip",
	  "unzip serf_0.7.0_linux_amd64.zip",
	  "rm /opt/serf_0.7.0_linux_amd64.zip",
	  "service serf start",
	  "curl -s -S https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz | tar -C /usr/local -xz",
	  "export PATH=$PATH:/usr/local/go/bin:/go/bin",
	  "export GOPATH=/go",
	  "curl -sO https://github.com/google/protobuf/releases/download/v3.0.0-beta-2/protoc-3.0.0-beta-2-linux-x86_64.zip",
	  "unzip protoc-3.0.0-beta-2-linux-x86_64.zip",
	  "mv /opt/protoc-3.0.0-beta-2-linux-x86_64/protoc /go/bin",
	  "rm -fr /opt/protoc-3.0.0-beta-2-linux-x86_64*",
	  "go get -u github.com/golang/protobuf/{proto,protoc-gen-go}",
	  "go get -u golang.org/x/net/http2",
	  "go get -u google.golang.org/grpc",
	  "mkdir -p /go/src/github.com",
	  "cd /go/src/github.com",
	  "git clone https://${element(split(",", var.repositories), count.index)}"
	]
  }

  count = "${length(split(",", var.repositories))}"
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
