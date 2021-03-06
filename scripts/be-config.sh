#!/usr/bin/env bash

pm2_dir=/usr/local/bin

# Cloning movie-analyst-api from github
cd ~/
if [[ -d movie-analyst-api ]]; then
  git -C movie-analyst-api pull
else
  git clone https://github.com/jocamp18/movie-analyst-api.git
fi
cd movie-analyst-api

# Installing or updating prerequisites for the app
if [ $(node --version) ]; then
  echo "npm already installed"
else
  curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
  sudo yum install nodejs -y
fi

npm install
if [ $(ls $pm2_dir/pm2 2>/dev/null) ]; then
  echo "pm2 already installed"
else
  sudo npm install -g pm2 
fi

# Starting app using pm2
pm2Status=$(node $pm2_dir/pm2 status | grep movie-api)
if [[ -z "$pm2Status" ]]; then
  node $pm2_dir/pm2 start ecosystem.config.js
else
  appStatus=$(echo $pm2Status | grep online)
  if [[ -z "$appStatus" ]]; then
    node $pm2_dir/pm2 restart ecosystem.config.js
  else
    echo "Api already deployed"
  fi
fi

# Adding cron to start app on reboot
cronStatus=$(crontab -l)
if [[ -z "$cronStatus" ]]; then
  crontab $HOME/movie-analyst-devops/config-files/be-cron
else
  echo "Crontab already added"
fi

echo "Configuration of API have finished. Enjoy it!"
