#!/bin/bash -e

#Installing mysql cli
sudo apt-get install mariadb-client -y
sleep 2
if ! command -v mysql > /dev/null 2>&1 ; then
    echo "mysql is not installed"
fi
