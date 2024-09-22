#!/bin/bash

set -e

# Nginx Installation

sudo apt-get update
sudo apt-get install nginx -y

#Deploying the ssl files

sudo mkdir -p /etc/nginx/ssl
ls -ltra
pwd
sudo mv /tmp/paynpro_certificate/paynpro_com.crt /etc/nginx/ssl/
sudo mv /tmp/paynpro_certificate/paynpro_com.key /etc/nginx/ssl/
sudo mv /tmp/paynpro_certificate/www.paynpro.com.chained.crt /etc/nginx/ssl/

# changing nginx config file

old_file="/etc/nginx/sites-available/default"

new_file="/tmp/nginx_conf_file/paynpro_com.conf"

if [ ! -f "$new_file" ]; then
  echo "Error: New configuration file $new_file does not exist."
  exit 1
fi

if diff "$old_file" "$new_file" >/dev/null; then
  echo "No changes detected."
else
  echo "Changes detected. Updating $old_file with contents of $new_file."
  cp "$new_file" "$old_file"
  sudo nginx -t
fi
