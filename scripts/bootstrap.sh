#!/usr/bin/env bash

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

dnf install git npm vim -y
