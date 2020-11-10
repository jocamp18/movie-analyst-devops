#!/usr/bin/env bash

# Cloning movie-analyst-ui from github
cd ~/
if [[ -d movie-analyst-ui ]]; then
  git -C movie-analyst-ui pull
else
  git clone https://github.com/jocamp18/movie-analyst-ui.git
fi
cd movie-analyst-ui

# Installing or updating prerequisites for the app
npm install
sudo npm install -g pm2

# Starting app using pm2
pm2Status=$(/usr/bin/node /usr/bin/pm2 status | grep movie-ui)
if [[ -z "$pm2Status" ]]; then
  /usr/bin/node /usr/bin/pm2 start ecosystem.config.js
else
  appStatus=$(echo $pm2Status | grep online)
  if [[ -z "$appStatus" ]]; then
    /usr/bin/node /usr/bin/pm2 restart ecosystem.config.js
  else
    echo "App already deployed"
  fi
fi

# Adding cron to start app on reboot
cronStatus=$(crontab -l)
if [[ -z "$cronStatus" ]]; then
  crontab $HOME/movie-analyst-devops/config-files/fe-cron
else
  echo "Crontab already added"
fi

echo "Configuration of UI have finished. Enjoy it!"
