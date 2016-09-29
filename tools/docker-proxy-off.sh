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

source "/opt/inist-tools/libs/std.rc"

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


if [ "$platform" == "debian" ]; then

  _it_std_consoleMessage "INFO" "Debian → systemd"
  # Suppression de la conf spécifique au proxy INIST
  rm /etc/systemd/system/docker.service.d/inist-tools.conf
  # Prise en charge du changement de la conf et redémarrage du service
  systemctl daemon-reload
  sleep 1
  systemctl restart docker
  
elif [ "$platform" == "ubuntu" ]; then
  #
  echo "ExecStart=/usr/bin/docker daemon \$DOCKER_OPTS -H fd://" >> /etc/systemd/system/docker.service.d/http-proxy.conf
  #
  ubuntuVersion=$(cat /etc/lsb-release | grep -i "DISTRIB_RELEASE" | cut -d"=" -f 2)
  ubuntuMajor=$(echo "$ubuntuVersion" | cut -d"." -f 1)
  ubuntuMinor=$(echo "$ubuntuVersion" | cut -d"." -f 2)
  
  case $ubuntuVersion in
  
    # UPSTART (on considère qu'on utilise pas de version < 12.04)
    "12.04" | "12.10" | "13.04" | "13.10" | "14.04" | "14.10" )
      _it_std_consoleMessage "INFO" "Ubuntu $ubuntuVersion → utilisation de upstart"
      # confUpstart <--- INUTILE !
      service docker restart
    ;;
    
    # SYSTEMD (toutes les autres version d'Ubuntu >= 15.04)
    * )
      _it_std_consoleMessage "INFO" "Ubuntu $ubuntuVersion → utilisation de systemd"
      # Suppression de la conf spécifique au proxy INIST
      rm /etc/systemd/system/docker.service.d/http-proxy.conf
      # Prise en charge du changement de la conf et redémarrage du service
      systemctl daemon-reload
      sleep 1
      systemctl restart docker
    ;;
    
  esac

fi

# ------------------------------------------------------------------------------
# Sortie propre
# ------------------------------------------------------------------------------
exit 0
