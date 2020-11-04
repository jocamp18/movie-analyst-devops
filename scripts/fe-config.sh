#!/usr/bin/env bash

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

dnf install git npm vim -y
cd ~/
git clone https://github.com/jocamp18/movie-analyst-ui.git
cd movie-analyst-ui
npm install
sudo npm install -g pm2
pm2 start ecosystem.config.js
crontab /vagrant/config-files/fe-cron
