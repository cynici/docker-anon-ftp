#!/usr/bin/env bash
#
# Use this wrapper script as Docker entrypoint to set the UID and GID
# of postgres user in container to fix data files owner
#
# CAVEAT:
# - security risk if either value conflicts already in-use in the container
#
set -eux
_uid="${FTP_UID:-}"
_gid="${FTP_GID:-}"
if [ -n "$_uid" ] && [ -n "$_gid" ] ; then
    groupmod --gid ${FTP_GID} ftp
    usermod --uid ${FTP_UID} ftp
fi

[ -f /vsftpd.conf.tmpl ] && {
    dockerize -template /vsftpd.conf.tmpl:/etc/vsftpd.conf
    chown root:root /etc/vsftpd.conf
}

[ -d /etc/vsftpd ] && {
    chown -R root:root /etc/vsftpd
    chmod 750 /etc/vsftpd
    chmod 600 /etc/vsftpd/*
}

exec "$@"
