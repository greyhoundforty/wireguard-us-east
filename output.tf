resource "local_file" "wireguard_client_config" {
  depends_on = [ibm_is_instance.wireguard_instance]
  content    = <<EOF
[Interface]
PrivateKey = ${var.client_public_key}
Address = 192.168.0.3/24

[Peer]
PublicKey = SERVER_PUBLIC_KEY_PLACEHOLDER
Endpoint = ${ibm_is_floating_ip.regional_fip.address}:51820
AllowedIPs = ${ibm_is_subnet.regional_z1_subnet.ipv4_cidr_block}, ${ibm_is_subnet.regional_z2_subnet.ipv4_cidr_block}, ${ibm_is_subnet.regional_z3_subnet.ipv4_cidr_block}, 166.8.0.0/14

EOF

  filename = "${path.cwd}/wg0.conf"
}

output "wg_fip" {
  value = ibm_is_floating_ip.regional_fip.address
}