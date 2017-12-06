#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / docker-proxy-on.sh
# 
# Sous-routine qui positionne le proxy inist pour DOCKER
#
# /!\ S'execute en ROOT
#
# @author : INIST-CNRS/DPI
#
################################################################################

source "/opt/inist-tools/libs/std.rc"
source "/opt/inist-tools/libs/ansicolors.rc"

# PROXY
#INIST_HTTP_PROXY="http://proxyout.inist.fr:8080"
#INIST_HTTPS_PROXY="http://proxyout.inist.fr:8080"
#INIST_FTP_PROXY="http://proxyout.inist.fr:8080"
#INIST_PROXYPAC="http://proxypac.intra.inist.fr/proxy.pac"
#INIST_NO_PROXY="localhost,127.0.0.0/8,*.local,172.16.0.0/16"
#INIST_PROXY_ADDRESS="http://proxyout.inist.fr"
#INIST_PROXY_PORT="8080"

if [ ! -f /etc/docker/daemon.json ] || [ "$(cat /etc/docker/daemon.json)" == "" ]; then
  echo "{}" > /etc/docker/daemon.json
fi
if [ -f /etc/docker/daemon.json ]; then
  TMPFILE=$(tempfile)
  cat /etc/docker/daemon.json \
    | jq '.dns += [ "172.16.128.28", "172.16.128.32" ]' \
    | jq '."insecure-registries" += [ "vsregistry.intra.inist.fr:5000" ]' \
     > $TMPFILE
  cp -f $TMPFILE /etc/docker/daemon.json
  rm -f $TMPFILE
fi

mkdir -p /etc/systemd/system/docker.service.d/
echo "# inist-tools" > /etc/systemd/system/docker.service.d/inist-tools.conf
echo "[Service]" >> /etc/systemd/system/docker.service.d/inist-tools.conf
echo "Environment=\"HTTP_PROXY=$INIST_HTTP_PROXY\" \"http_proxy=$INIST_HTTP_PROXY\" \"HTTPS_PROXY=$INIST_HTTPS_PROXY\" \"https_proxy=$INIST_HTTPS_PROXY\" \"NO_PROXY=$INIST_NO_PROXY\"" >> /etc/systemd/system/docker.service.d/inist-tools.conf

/opt/inist-tools/tools/service-restart.sh "docker" &

# ------------------------------------------------------------------------------
# Sortie propre
# ------------------------------------------------------------------------------
exit 0
