# A simple docker image for git and repo tools
# https://github.com/shugaoye/docker-alpine-git

FROM alpine

LABEL maintainer="shugaoye@yahoo.com"

RUN apk --update add bash git less openssh sudo curl python3 gnupg perl tmux mc && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo && \
    chmod a+x /bin/repo && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

RUN mkdir /var/run/sshd
RUN export LC_ALL=C

#RUN echo 'root:root' | chpasswd
#RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
#RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

EXPOSE 22

COPY utils/ssh_config/ssh_* /etc/ssh/
#CMD    ["/usr/sbin/sshd", "-D"]

#USER devel
#ENV HOME=/home/devel
WORKDIR /home

ONBUILD USER root
ONBUILD WORKDIR /

COPY utils/docker_entrypoint.sh /root/docker_entrypoint.sh
COPY utils/bashrc /root/bashrc
ENTRYPOINT ["/root/docker_entrypoint.sh"]