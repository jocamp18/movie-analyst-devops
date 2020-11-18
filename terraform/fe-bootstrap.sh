#!/bin/bash

yum install npm vim git -y
amazon-linux-extras install ansible2 -y

git -b feat-terraform clone https://github.com/jocamp18/movie-analyst-devops
cd movie-analyst-devops/ansible

ansible-playbook -i inventory/ -e "ansible_group=uife os_version=amz" site.yml
