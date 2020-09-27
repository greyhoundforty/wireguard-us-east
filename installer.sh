#!/usr/bin/env bash

## Update machine
DEBIAN_FRONTEND=noninteractive apt -qqy update
DEBIAN_FRONTEND=noninteractive apt-get -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' dist-upgrade

## Install Docker 
DEBIAN_FRONTEND=noninteractive apt -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install curl git python3-pip wireguard at 

systemctl enable --now atd

## Generate Wireguard Public and Private Keys
/usr/bin/wg genkey | tee /etc/wireguard/privatekey | /usr/bin/wg pubkey | tee /etc/wireguard/publickey

## Install consul
snap install consul 

export CONSUL_HTTP_ADDR="${consul_http}"
export CONSUL_HTTP_TOKEN="${consul_token}"

/snap/bin/consul kv put wireguard/server_public_key `cat /etc/wireguard/publickey`
/snap/bin/consul kv put wireguard/server_private_key `cat /etc/wireguard/privatekey`


## Generate Wireguard configuration file 
cat <<EOF > /etc/wireguard/wg0.conf
[Interface]
Address = 192.168.0.2/24
SaveConfig = true
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o ens3 -j MASQUERADE
ListenPort = 51820
PrivateKey = PRIVATE_KEY_PLACEHOLDER

[Peer]
PublicKey = ${client_public_key}
EOF 

PRIVATE_KEY=`cat /etc/wireguard/privatekey`

sed -i "|PRIVATE_KEY_PLACEHOLDER|$PRIVATE_KEY|" /etc/wireguard/wg0.conf

cat <<EOF > /var/lib/cloud/scripts/per-once 

systemctl enable wg-quick@wg0

EOF 

chmod +x /var/lib/cloud/scripts/per-once

echo "reboot" | at now + 2 minutes

