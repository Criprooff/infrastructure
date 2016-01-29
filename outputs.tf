output "ip_addresses" {
  value = "${join(", ", digitalocean_droplet.serf.*.ipv4_address)}"
}
