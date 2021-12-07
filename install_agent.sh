#! /bin/sh
docker rm -f bamboo-docker-agent 
docker pull atlassian/bamboo-agent-base
docker volume create --name bambooVolume
docker build --tag bamboo-docker-agent --build-arg BAMBOO_VERSION=8.0.4 .
cat ./password.txt | docker login --username admin --password-stdin focal:8181
docker tag bamboo-docker-agent:latest focal:8181/bamboo-docker-agent:latest
docker image push focal:8181/bamboo-docker-agent:latest
docker run -e BAMBOO_SERVER=http://192.168.56.101:8085/agentServer/ -v bambooVolume:/var/atlassian/application-data/bamboo-agent -v /var/run/docker.sock:/var/run/docker.sock --name="bamboo-docker-agent" --init --hostname="bambooAgent" -d bamboo-docker-agent
