#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install docker.io
sudo docker run --name adminer -p 8080:8080 adminer


sudo service apache2 start