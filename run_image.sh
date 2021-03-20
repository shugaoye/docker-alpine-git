#!/bin/sh

USER_ID=`id -u`
USERNAME=`id -un`
GROUP_ID=`id -g`
GROUPNAME=`id -gn`

if [ -n "$1" ]; then
        IMAGE=$1
else
        IMAGE=shugaoye/docker-alpine-git:latest
fi

vol1="$(cd ..; pwd)"
# Running from the current folder and set the parent folder as a volume
docker run -ti --rm \
  -v ${vol1}:/home/${USERNAME} \
  -p 22:22 \
  -p 8388:8388 \
  -e USER_ID=${USER_ID} -e GROUP_ID=${GROUP_ID} \
  -e USERNAME=${USERNAME} -e GROUPNAME=${GROUPNAME} \
  ${IMAGE} /bin/sh