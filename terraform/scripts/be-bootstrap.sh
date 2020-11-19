#!/bin/bash

yum install npm vim git -y
amazon-linux-extras install ansible2 -y

git clone -b feat-terraform https://github.com/jocamp18/movie-analyst-devops
cd movie-analyst-devops/ansible

ansible-playbook -i inventory/ -e "ansible_group=apibe os_version=amz" site.yml
