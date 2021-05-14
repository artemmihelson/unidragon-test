# README

## Project setup

1. If you want to install project to the cleanly system, please stop all containers by the command: __docker stop $(docker ps -aq)__. Then run step-by-step __./docker-prune-containers__, __./docker-prune-images__ and __./docker-prune-volumes__.
2. First time or each time you changed ./build/** files - run __./docker-rebuild__.
3. To everyday running docker use - __./docker-daemon-start__.
4. To stop docker use - __./docker-daemon-stop__. 

## Docker basic information

* Docker Basics in X hours and Y days [RU] - https://habr.com/post/337306/