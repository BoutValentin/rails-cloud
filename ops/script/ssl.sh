#!/bin/sh

# This script cannot be launch without stdin
# Needed to put some TXT value to the DNS

certbot certonly \
  --agree-tos \
  --email $1 \
  --manual \
  --preferred-challenges=dns \
  -d $2 \
  --server https://acme-v02.api.letsencrypt.org/directory
