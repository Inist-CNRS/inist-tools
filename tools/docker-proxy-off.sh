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
source "/opt/inist-tools/libs/ansicolors.rc"

# ------------------------------------------------------------------------------
# Variables globales
# ------------------------------------------------------------------------------
DOCKER_DEFAULT_FILE="/etc/default/docker"
INIST_TOOLS_CONF_DIR="/etc/systemd/system/docker.service.d"
INIST_TOOLS_CONF_FILE="$INIST_TOOLS_CONF_DIR/inist-tools.conf"
TMPFILE="/run/shm/tmpfile$$"

# ------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------
grep -vi "inist\.fr" "$DOCKER_DEFAULT_FILE" | tr -s '\n' > "$TMPFILE"
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
#  echo "ExecStart=/usr/bin/docker daemon \$DOCKER_OPTS -H fd://" >> /etc/systemd/system/docker.service.d/http-proxy.conf
  echo "ExecStart=/usr/bin/docker daemon \$DOCKER_OPTS -H fd://" >> "$INIST_TOOLS_CONF_FILE"
  #
  ubuntuVersion=$(cat /etc/lsb-release | grep -i "DISTRIB_RELEASE" | cut -d"=" -f 2 | tr -d".")
  ubuntuMajor=$(echo "$ubuntuVersion" | cut -d"." -f 1)
  ubuntuMinor=$(echo "$ubuntuVersion" | cut -d"." -f 2)
  
  case $ubuntuVersion in
  
    # UPSTART (on considère qu'on utilise pas de version < 12.04)
    "1204" | "1210" | "1304" | "1310" | "1404" | "1410" )
      # _it_std_consoleMessage "INFO" "Ubuntu $ubuntuVersion → utilisation de upstart"
      # confUpstart <--- INUTILE !
      _it_std_consoleMessage "ACTION" "relance du daemon docker..."
      service docker restart >> /dev/null 2>&1
      if [ $? == 0 ]; then
        _it_std_consoleMessage "OK" "docker redémarré"
      else
        _it_std_consoleMessage "NOK" "docker n'est pas redémarré"
        return $FALSE
      fi
    ;;
    
    # SYSTEMD (toutes les autres version d'Ubuntu >= 15.04)
    * )
      # _it_std_consoleMessage "INFO" "Ubuntu $ubuntuVersion → utilisation de systemd"
      # Suppression de la conf spécifique au proxy INIST
      rm /etc/systemd/system/docker.service.d/http-proxy.conf
      # Prise en charge du changement de la conf et redémarrage du service
      _it_std_consoleMessage "ACTION" "relance du daemon docker..."
      systemctl daemon-reload >> /dev/null 2>&1
      if [ $? == 0 ]; then
        _it_std_consoleMessage "OK" "daemon docker relancé avec succès"
      else
        _it_std_consoleMessage "NOK" "daemon docker n'est pas reparti"
        return $FALSE
      fi
      sleep 1
      _it_std_consoleMessage "ACTION" "redémarrage du daemon docker..."
      systemctl restart docker >> /dev/null 2>&1
      if [ $? == 0 ]; then
        _it_std_consoleMessage "OK" "docker redémarré"
      else
        _it_std_consoleMessage "NOK" "docker n'est pas redémarré"
        return $FALSE
      fi
    ;;
    
  esac

fi

# ------------------------------------------------------------------------------
# Sortie propre
# ------------------------------------------------------------------------------
exit 0
