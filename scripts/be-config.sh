#!/usr/bin/env bash

# Cloning movie-analyst-ui from github
cd ~/
if [[ -d movie-analyst-api ]]; then
  git -C movie-analyst-api pull
else
  git clone https://github.com/jocamp18/movie-analyst-api.git
fi
cd movie-analyst-api

# Installing or updating prerequisites for the app
npm install
sudo npm install -g pm2

# Starting app using pm2
pm2Status=$(/usr/bin/node /usr/local/bin/pm2 status | grep movie-api)
if [[ -z "$pm2Status" ]]; then
  /usr/bin/node /usr/local/bin/pm2 start ecosystem.config.js
else
  appStatus=$(echo $pm2Status | grep online)
  if [[ -z "$appStatus" ]]; then
    /usr/bin/node /usr/local/bin/pm2 restart ecosystem.config.js
  else
    echo "Api already deployed"
  fi
fi

# Adding cron to start app on reboot
cronStatus=$(crontab -l)
if [[ -z "$cronStatus" ]]; then
  crontab ~/movie-analyst-devops/config-files/be-cron
else
  echo "Crontab already added"
fi

echo "Configuration of API have finished. Enjoy it!"
