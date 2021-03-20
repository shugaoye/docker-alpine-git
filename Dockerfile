# A simple docker image for git and repo tools
# https://github.com/shugaoye/docker-alpine-git

FROM alpine:3.12

LABEL maintainer="shugaoye@yahoo.com"

RUN apk --update add bash git less openssh sudo curl python3 gnupg \
    perl tmux mc c-ares libcrypto1.1 libev libsodium mbedtls pcre && \
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

# Setup ss-server
ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 8388
ENV METHOD      aes-256-cfb
ENV PASSWORD=
ENV TIMEOUT     60
ENV DNS_ADDR    8.8.8.8

EXPOSE $SERVER_PORT/tcp
EXPOSE $SERVER_PORT/udp

COPY utils/ss-server /usr/local/bin/ss-server

#USER devel
#ENV HOME=/home/devel
WORKDIR /home

ONBUILD USER root
ONBUILD WORKDIR /

COPY utils/docker_entrypoint.sh /root/docker_entrypoint.sh
COPY utils/bashrc /root/bashrc
ENTRYPOINT ["/root/docker_entrypoint.sh"]

CMD ss-server -s "$SERVER_ADDR" \
              -p "$SERVER_PORT" \
              -m "$METHOD"      \
              -k "$PASSWORD"    \
              -t "$TIMEOUT"     \
              -d "$DNS_ADDR"    \
              -u                \
              --fast-open $OPTIONS