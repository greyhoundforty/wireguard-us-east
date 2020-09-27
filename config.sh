#!/usr/bin/env bash

SERVER_PUBLIC_KEY=`consul kv get wireguard/server_public_key`

sed -i "s|SERVER_PUBLIC_KEY_PLACEHOLDER|${SERVER_PUBLIC_KEY}|" wg0.conf