#!/bin/bash
sudo apt update && sudo apt install -y docker.io # && sudo mkdir /mnt/tmp

#sudo apt install -y mc

#sudo apt-get install samba
#smbd start

echo "KUKUKU!!!"

#sudo docker pull efrecon/s3fs

# sudo docker run -d --rm \
# --device /dev/fuse \
# --cap-add SYS_ADMIN \
# --security-opt "apparmor=unconfined" \
# --env "AWS_S3_BUCKET=om-data" \
# --env "AWS_S3_ACCESS_KEY_ID=AKIAT***********" \
# --env "AWS_S3_SECRET_ACCESS_KEY=2AQN0WgWcpm*************" \
# --env UID=$(id -u) \
# --env GID=$(id -g) \
# -v /mnt:/opt/s3fs/bucket:rshared \
# efrecon/s3fs:latest

# sudo docker run --rm \
# -p 8888:8888/tcp \
# -p 5000-5050:5000-5050/udp \
# -e KMS_MIN_PORT=5000 \
# -e KMS_MAX_PORT=5050 \
# kurento/kurento-media-server:latest

sudo docker run -d --name kms -p 8888:8888 kurento/kurento-media-server:latest


