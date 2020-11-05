# movie-analyst-devops
Automation of movie-analyst app deployment.
## Usage

Clone the repo.

`git clone https://github.com/jocamp18/movie-analyst-devops`

Enter to the repo directory and execute vagran command to start the machines.

`cd movie-anayst-devops`

`vagrant up`

Now the base machines will be available

## Frontend

 Enter to frontend machine with root user.

`vagrant ssh frontend`

`sudo su -`

Enter to the repo directory. Go to scripts folder and execute the script fe-config.sh

`cd movie-anayst-devops/scripts`

`./fe-config.sh`

## Backend

 Enter to backend machine with root user.

`vagrant ssh backend`

`sudo su -`

Enter to the repo directory. Go to scripts folder and execute the script fe-config.sh

`cd movie-anayst-devops/scripts`

`./be-config.sh`

## Git branching model

![arch_image]( ./doc/img/git-model.png)
