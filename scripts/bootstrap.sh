#!/usr/bin/env bash

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

dnf install git npm vim -y
cd ~/
git clone -b develop https://github.com/jocamp18/movie-analyst-devops
