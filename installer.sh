#!/bin/bash

## Update machine
DEBIAN_FRONTEND=noninteractive apt-get -qqy update
DEBIAN_FRONTEND=noninteractive apt-get -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade

## Install Wireguard and basic tools 
DEBIAN_FRONTEND=noninteractive apt-get -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install curl git wireguard at unzip resolvconf

systemctl enable --now atd

echo "net.ipv4.ip_forward=1" | tee -a /etc/sysctl.conf
sysctl -p

## Generate Wireguard Public and Private Keys
/usr/bin/wg genkey | tee /etc/wireguard/privatekey | /usr/bin/wg pubkey | tee /etc/wireguard/publickey

## Install consul
curl --silent --remote-name https://releases.hashicorp.com/consul/1.8.0/consul_1.8.0_linux_amd64.zip
unzip consul_1.8.0_linux_amd64.zip
chown root:root consul
mv consul /usr/bin/
consul -autocomplete-install

## Set keys
export CONSUL_HTTP_ADDR="${consul_http}"
export CONSUL_HTTP_TOKEN="${consul_token}"

consul kv put wireguard/server_public_key @/etc/wireguard/publickey
consul kv put wireguard/server_private_key @/etc/wireguard/privatekey

## Download Wireguard configuration file 
wget https://raw.githubusercontent.com/greyhoundforty/wireguard-us-east/master/wg0.conf-example
mv wg0.conf-example /etc/wireguard/wg0.conf

export CLIENT_PUBLIC_KEY=${client_public_key}
sed -i "s|CLIENT_PUBLIC_KEY_PLACEHOLDER|$CLIENT_PUBLIC_KEY|" /etc/wireguard/wg0.conf

PRIVATE_KEY=`cat /etc/wireguard/privatekey`

sed -i "s|PRIVATE_KEY_PLACEHOLDER|$PRIVATE_KEY|" /etc/wireguard/wg0.conf

systemctl enable wg-quick@wg0

wget https://raw.githubusercontent.com/greyhoundforty/wireguard-us-east/master/add-wg-peer.sh -O /root/add-wg-peer.sh
sed -i "s|CLIENT_PUBLIC_KEY_PLACEHOLDER|$CLIENT_PUBLIC_KEY|" /root/add-wg-peer.sh
chmod +x /root/add-wg-peer.sh

/usr/bin/at now + 1 minutes <<END
reboot
END

cat <<EOF > /var/lib/cloud/scripts/per-boot/schedule-tunnel.sh
#!/bin/bash
/usr/bin/at now + 5 minutes <<END
/root/add-wg-peer.sh
END

EOF

chmod +x /var/lib/cloud/scripts/per-boot/schedule-tunnel.sh
