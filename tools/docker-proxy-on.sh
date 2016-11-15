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

# ------------------------------------------------------------------------------
# Variables globales
# ------------------------------------------------------------------------------
DOCKER_DEFAULT_FILE="/etc/default/docker"
INIST_TOOLS_CONF_DIR="/etc/systemd/system/docker.service.d"
INIST_TOOLS_CONF_FILE="$INIST_TOOLS_CONF_DIR/inist-tools.conf"
DOCKEROPTS_CONF_FILE="/opt/inist-tools/conf/docker-opts.conf"

# PROXY
INIST_HTTP_PROXY="http://proxyout.inist.fr:8080"
INIST_HTTPS_PROXY="http://proxyout.inist.fr:8080"
INIST_FTP_PROXY="http://proxyout.inist.fr:8080"
INIST_PROXYPAC="http://proxypac.intra.inist.fr/proxy.pac"
INIST_NO_PROXY="localhost,127.0.0.0/8,*.local,172.16.0.0/16"
INIST_PROXY_ADDRESS="http://proxyout.inist.fr"
INIST_PROXY_PORT="8080"

# ------------------------------------------------------------------------------
# BACKUP !
# ------------------------------------------------------------------------------
cp "$DOCKER_DEFAULT_FILE" /etc/default/docker_inist-tools-backup

# ------------------------------------------------------------------------------
# Docker-opts personnalisés
# ------------------------------------------------------------------------------
if [ -a "$DOCKEROPTS_CONF_FILE" ]; then
  DOCKER_OPTS_CUSTOM=$(cat "$DOCKEROPTS_CONF_FILE")
fi

# ------------------------------------------------------------------------------
# conf docker
# ------------------------------------------------------------------------------
printf "\n" >> "$DOCKER_DEFAULT_FILE"
printf "DOCKER_OPTS=\"--dns 172.16.100.17 --dns 172.16.100.16 --insecure-registry vsregistry.intra.inist.fr:5000 $DOCKER_OPTS_CUSTOM\"\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "HTTP_PROXY=\"$INIST_HTTP_PROXY\"\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "HTTPS_PROXY=\"$INIST_HTTPS_PROXY\"\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "export HTTP_PROXY=\"$INIST_HTTP_PROXY\"\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "export HTTPS_PROXY=\"$INIST_HTTPS_PROXY\"\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "http_proxy=\"$INIST_HTTP_PROXY\"\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "https_proxy=\"$INIST_HTTPS_PROXY\"\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "export http_proxy=\"$INIST_HTTP_PROXY\"\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "export https_proxy=\"$INIST_HTTPS_PROXY\"\n" >> "$DOCKER_DEFAULT_FILE" 2>&1



function confSystemd {
  # Modification de la conf
  mkdir -p "$INIST_TOOLS_CONF_DIR"
  
  if [ -f "$INIST_TOOLS_CONF_FILE" ]; then
    rm "$INIST_TOOLS_CONF_FILE"
  fi
  
  touch "$INIST_TOOLS_CONF_FILE"
  
  echo "# inist-tools" >> "$INIST_TOOLS_CONF_FILE"
  echo "[Service]" >> "$INIST_TOOLS_CONF_FILE"
  echo "ExecStart=" >> "$INIST_TOOLS_CONF_FILE"
  echo "ExecStart=/usr/bin/docker daemon \$DOCKER_OPTS -H fd://" >> "$INIST_TOOLS_CONF_FILE"
  echo "EnvironmentFile=/etc/default/docker" >> "$INIST_TOOLS_CONF_FILE"

  # Prise en charge de la conf et redémarrage du service
  systemctl daemon-reload
  sleep 1
  systemctl restart docker
}

function confUpstart {
  # Modification de la conf
  if [ -f /etc/init/docker.override ]; then
    rm /etc/init/docker.override
  fi
  
  touch /etc/init/docker.override
  
  echo "# inist-tools" >> /etc/init/docker.override
  echo "[Service]" >> /etc/init/docker.override
  echo "ExecStart=" >> /etc/init/docker.override
  echo "ExecStart=/usr/bin/docker daemon \$DOCKER_OPTS -H fd://" >> /etc/init/docker.override
  echo "EnvironmentFile=/etc/default/docker" >> /etc/init/docker.override

  # Prise en charge de la conf et redémarrage du service
  _it_std_consoleMessage "ACTION" "relance du daemon docker..."
  service docker restart
  if [ $? == 0 ]; then
    _it_std_consoleMessage "OK" "docker redémarré"
  else
    _it_std_consoleMessage "NOK" "docker n'est pas redémarré"
    return $FALSE
  fi
}


# ------------------------------------------------------------------------------
# Service
# ------------------------------------------------------------------------------
is_debian=$(cat /etc/issue | grep -i "debian")
is_ubuntu=$(cat /etc/issue | grep -i "ubuntu")

if [ "$is_debian" ]; then
  platform="debian"
elif [ "$is_ubuntu" ]; then
  platform="ubuntu"
else
  platform="unknown"
fi


if [ "$platform" == "debian" ]; then

  _it_std_consoleMessage "INFO" "Debian → systemd"
  confSystemd
  
elif [ "$platform" == "ubuntu" ]; then

  ubuntuVersion=$(cat /etc/lsb-release | grep -i "DISTRIB_RELEASE" | cut -d"=" -f 2 | tr --delete ".")
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
        exit $FALSE
      fi
    ;;
    
    # SYSTEMD (toutes les autres version d'Ubuntu >= 15.04)
    * )
      # _it_std_consoleMessage "INFO" "Ubuntu $ubuntuVersion → utilisation de systemd"
      confSystemd >> /dev/null 2>&1
    ;;
    
  esac

fi

# ------------------------------------------------------------------------------
# Sortie propre
# ------------------------------------------------------------------------------
exit 0
