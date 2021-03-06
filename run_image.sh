#!/bin/sh

USER_ID=`id -u`
USERNAME=`id -un`
GROUP_ID=`id -g`
GROUPNAME=`id -gn`

if [ -n "$1" ]; then
        IMAGE=$1
else
        IMAGE=shugaoye/git:latest
fi

vol1="$(cd ..; pwd)"
# Running from the current folder and set the parent folder as a volume
docker run -ti --rm -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ${vol1}:/home/src \
  --net=host \
  -e USER_ID=${USER_ID} -e GROUP_ID=${GROUP_ID} \
  -e USERNAME=${USERNAME} -e GROUPNAME=${GROUPNAME} \
  ${IMAGE} /bin/sh