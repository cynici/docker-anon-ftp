FROM metabrainz/base-image

ARG DOCKERIZE_VERSION=v0.6.1

RUN apt-get update \
    && apt-get install -y --no-install-recommends vsftpd libpam-pwdfile \
 && apt-get install -y wget \
 && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
 && tar -C /usr/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
 && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
 && apt-get -y remove --purge wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/vsftpd/empty \
 && mkdir -p /etc/vsftpd \
 && mkdir -p /var/ftp \
 && mv /etc/vsftpd.conf /etc/vsftpd.orig \
 && mkdir /etc/service/vsftpd

ADD vsftpd.sh /etc/service/vsftpd/run
ADD docker-entrypoint.sh /docker-entrypoint.sh
ADD vsftpd.pam /etc/pam.d/vsftpd

VOLUME ["/var/ftp"]

EXPOSE 20-21
EXPOSE 65500-65515
