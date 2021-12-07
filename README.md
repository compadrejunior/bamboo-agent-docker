# bamboo-agent-docker
Tutorial: Configure and install a Bamboo Docker Agent to run your builds

## Overview
This procedure creates a Docker image based on a Dockerfile to be run as a Bamboo Agent Server container. The base image source is from [atlassian/bamboo-agent-base](https://hub.docker.com/r/atlassian/bamboo-agent-base). This image will be pushed into your private Docker registry after built so, it's important to set your private repository ip and port as well as your password as instructed bellow.

## Benefits
This procedures will grant you the ability to set containers with all capacities you need without the requirement to set this configuration inside the bamboo adminsitration pages. 

## Requirements
- You must have a Bamboo Server running.
- Docker should be installed in the machine where the docker agent image will be installed
- The server must have internet connectivity to pull atlassian/bamboo-agent-base images from Docker Hub
- Bamboo Broker client URL must be set to allow the agent comunication 

## Instructions
1. Edit the Dockerfile to your preferred build capabilities. E.g. Python
2. Edit the install_agent.sh to set your Bamboo Server ip and port in the following line
```bash
docker run -e BAMBOO_SERVER=http://192.168.56.101:8085/agentServer/
```
3. Edit the install_agent.sh to set your private repository ip and port to push your images. Don't forget to change your password in the password.txt as well.
```bash
cat ./password.txt | docker login --username admin --password-stdin focal:8181
```
4. Change the install_agent.sh to make it executable
```bash
sudo chmod 755 ./install_agent.sh
```
5. Run the install_agent.sh
```bash
$ ./install_agent.sh
```
### Inside Bamboo:
6. Aprove the Agent in the Administration > Agents > Agent authentication.
7. Wait a minute untill the Agent is up and chating with Bamboo server.
8. Create a plan and enable the Docker Agent in the Job Configuration > Docker.
9. Setup the Volumes host directory and container directory according to the volume created by the install script. To check how to do this check your sourde volume configuration with the docker inspect command. E.g.:
```bash
 docker volume inspect bambooVolume
```
10. The output should be like the example bellow:
```json
[
    {
        "CreatedAt": "2021-12-07T00:38:02Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/bambooVolume/_data",
        "Name": "bambooVolume",
        "Options": {},
        "Scope": "local"
    }
]
```
11. The container directory should be the same as defined in the install script in the following line:
```bash
docker run -e BAMBOO_SERVER=http://192.168.56.101:8085/agentServer/ -v bambooVolume:/var/atlassian/application-data/bamboo-agent 
```
12. Save your changes.
13. Add your tasks.
14. Run your build.