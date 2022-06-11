#!/bin/bash

sudo apt update && sudo apt install docker.io -y

#docker pull ghcr.io/serwol2/openmeetings-dp:feature-v1.0.0 && 
#docker pull ghcr.io/serwol2/openmeetings-dp/openmeetings-dp:feature-v1.0.0 #&& sudo docker run -i --restart=always --network host ghcr.io/serwol2/openmeetings-dp/openmeetings-dp:feature-v1.0.0
docker pull ghcr.io/serwol2/openmeetings-dp/openmeetings-dp:feature-v3.0.0-min-old