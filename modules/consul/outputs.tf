output "ip_addresses" {
  value = "${join(", ", digitalocean_droplet.consul.*.ipv4_address)}"
}

