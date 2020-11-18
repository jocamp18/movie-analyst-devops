#!/usr/bin/env bash

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

dnf install git npm vim -y
cd ~/
if [[ -d movie-analyst-devops ]]; then
  git -C movie-analyst-devops pull
else
  git clone -b feat-ansible https://github.com/jocamp18/movie-analyst-devops
fi
