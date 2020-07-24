#!/bin/bash

apt update
apt install -y nginx
systemctl start nginx
systemctl enable nginx

apt install -y mysql-client-core-5.7


