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
rm "$TMPFILE"

# ------------------------------------------------------------------------------
# Service
# ------------------------------------------------------------------------------

# Debian + Ubunu >= 15.04 -> systemd
# Ubuntu 14.04 -> upstart + fichiers sysvinit

is_debian=$(cat /etc/issue | grep -i "debian")
is_ubuntu=$(cat /etc/issue | grep -i "ubuntu")

if [ ! -z "$is_debian" ]; then
  platform="debian"
elif [ ! -z "$is_ubuntu" ]; then
  platform="ubuntu"
else
  platform="unknown"
fi

# Suppression de la conf spécifique au proxy INIST
rm /etc/systemd/system/docker.service.d/http-proxy.conf

if [ $platform == "debian" ]; then
  cp /etc/systemd/system/docker.service.d/http-proxy.conf /etc/systemd/system/docker.service.d/http-proxy.conf_inis-tools-backup
  # cp "$TMPFILE" /etc/systemd/system/docker.service.d/http-proxy.conf
  systemctl daemon-reload
  sleep 1
  systemctl restart docker
  sleep 1
  /etc/init.d/docker restart
elif [ $platform == "ubuntu" ]; then
  ubuntuVersion=$(cat /etc/lsb-release | grep -i "DISTRIB_RELEASE" | cut -d"=" -f 2)
  _it_std_consoleMessage "CHECK" "Ubuntu « $ubuntuVersion » détecté"
  case $ubuntuVersion in
    "12.04" | "12.10" | "13.04" | "13.10" | "14.04" | "14.10" )
      _it_std_consoleMessage "CHECK" "Utilisation de « update-rc.d »"
      sudo update-rc.d docker defaults
      sleep 1
      service docker restart
    ;;
    * )
      _it_std_consoleMessage "CHECK" "Utilisation de « systemctl »"
      systemctl daemon-reload
      sleep 1
      systemctl restart docker
      sleep 1
      /etc/init.d/docker restart
    ;;
  esac
fi

# ------------------------------------------------------------------------------
# Sortie propre
# ------------------------------------------------------------------------------
exit 0
