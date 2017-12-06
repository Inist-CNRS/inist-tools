#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / docker-proxy-off.sh
# 
# Sous-routine qui supprimer le proxy inist pour DOCKER
#
# /!\ S'execute en ROOT
#
# @author : INIST-CNRS/DPI
#
################################################################################

# ------------------------------------------------------------------------------
# Ressources
# ------------------------------------------------------------------------------
source "/opt/inist-tools/libs/std.rc"
source "/opt/inist-tools/libs/ansicolors.rc"

# ------------------------------------------------------------------------------
# Service
# ------------------------------------------------------------------------------

rm -f "/etc/systemd/system/docker.service.d/inist-tools.conf"

if [ -f /etc/docker/daemon.json ]; then
  TMPFILE=$(tempfile)
  cat /etc/docker/daemon.json \
    | jq '.dns -= [ "172.16.128.28", "172.16.128.32" ]' \
    | jq '."insecure-registries" -= [ "vsregistry.intra.inist.fr:5000" ]' \
     > $TMPFILE
  cp -f $TMPFILE /etc/docker/daemon.json
  rm -f $TMPFILE
fi

/opt/inist-tools/tools/service-restart.sh "docker" &

# ------------------------------------------------------------------------------
# Sortie propre
# ------------------------------------------------------------------------------
exit 0
