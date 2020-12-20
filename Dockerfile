# A simple docker image for git and repo tools
# https://github.com/shugaoye/docker-alpine-git

FROM alpine

LABEL maintainer="shugaoye@yahoo.com"

RUN apk --update add bash git less openssh sudo curl python3 gnupg && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo && \
    chmod a+x /bin/repo && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

#USER devel
#ENV HOME=/home/devel
WORKDIR /home

ONBUILD USER root
ONBUILD WORKDIR /

COPY utils/docker_entrypoint.sh /root/docker_entrypoint.sh
COPY utils/bashrc /root/bashrc
ENTRYPOINT ["/root/docker_entrypoint.sh"]