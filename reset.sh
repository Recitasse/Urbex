#!/bin/bash

# Stop MySQL service
sudo systemctl stop mysql

# Backup MySQL configuration
sudo cp /etc/mysql/my.cnf /etc/mysql/my.cnf.backup

# Remove MySQL packages and data
sudo apt-get remove --purge mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-*
sudo rm -rf /etc/mysql /var/lib/mysql
sudo apt-get autoremove
sudo apt-get autoclean

# Remove MySQL user and group
sudo deluser mysql
sudo delgroup mysql

