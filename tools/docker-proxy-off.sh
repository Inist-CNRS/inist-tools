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
# Variables globales
# ------------------------------------------------------------------------------
DOCKER_DEFAULT_FILE="/etc/default/docker"
TMPFILE="/run/shm/tmpfile$$"

# ------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------
grep -vi "# inist-tools" "$DOCKER_DEFAULT_FILE" > "$TMPFILE"
cp "$TMPFILE" "$DOCKER_DEFAULT_FILE"

# ------------------------------------------------------------------------------
# Service
# ------------------------------------------------------------------------------
is_debian=$(cat /etc/issue | grep -i "debian")
is_ubuntu=$(cat /etc/issue | grep -i "ubuntu")

if [ ! -z "$is_debian" ]; then
  platform="debian"
elif [ ! -z "$is_ubuntu" ]; then
  platform="ubuntu"
else
  platform="unknown"
fi

if [ $platform == "debian" ]; then
  cp /etc/systemd/system/docker.service.d/http-proxy.conf /etc/systemd/system/docker.service.d/http-proxy.conf_inis-tools-backup
  grep -vi "# inist-tools" /etc/systemd/system/docker.service.d/http-proxy.conf > "$TMPFILE"
  cp "$TMPFILE" /etc/systemd/system/docker.service.d/http-proxy.conf
elif [ $platform == "ubuntu" ]; then
  cp /lib/systemd/system/docker.service /lib/systemd/system/docker.service_inist-tools-backup
  grep -vi "# inist-tools" /lib/systemd/system/docker.service > "$TMPFILE"
  cp "$TMPFILE" /lib/systemd/system/docker.service
fi

# ------------------------------------------------------------------------------
# Sortie propre
# ------------------------------------------------------------------------------
exit 0
