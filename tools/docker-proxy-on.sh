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

# ------------------------------------------------------------------------------
# Variables globales
# ------------------------------------------------------------------------------
DOCKER_DEFAULT_FILE="/etc/default/docker"

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
# conf docker
# ------------------------------------------------------------------------------
printf "" >> "$DOCKER_DEFAULT_FILE"

printf "# inist-tools\n" >> "$DOCKER_DEFAULT_FILE" 2>&1

printf "DOCKER_OPTS=\"--dns 172.16.100.17 --dns 172.16.100.16\" # inist-tools" >> "$DOCKER_DEFAULT_FILE"

printf "HTTP_PROXY=\"$INIST_HTTP_PROXY\" # inist-tools\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "HTTPS_PROXY=\"$INIST_HTTPS_PROXY\" # inist-tools\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "export HTTP_PROXY=\"$INIST_HTTP_PROXY\" # inist-tools\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "export HTTPS_PROXY=\"$INIST_HTTPS_PROXY\" # inist-tools\n" >> "$DOCKER_DEFAULT_FILE" 2>&1

printf "http_proxy=\"$INIST_HTTP_PROXY\" # inist-tools\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "https_proxy=\"$INIST_HTTPS_PROXY\" # inist-tools\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "export http_proxy=\"$INIST_HTTP_PROXY\" # inist-tools\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "export https_proxy=\"$INIST_HTTPS_PROXY\" # inist-tools\n" >> "$DOCKER_DEFAULT_FILE" 2>&1


function confSystemd {
  # Modification de la conf
  mkdir -p /etc/systemd/system/docker.service.d/
  
  if [ -f /etc/systemd/system/docker.service.d/http-proxy.conf ]; then
    rm /etc/systemd/system/docker.service.d/http-proxy.conf
  fi
  
  touch /etc/systemd/system/docker.service.d/http-proxy.conf
  
  echo "# inist-tools" >> /etc/systemd/system/docker.service.d/http-proxy.conf
  echo "[Service]" >> /etc/systemd/system/docker.service.d/http-proxy.conf
  echo "ExecStart=" >> /etc/systemd/system/docker.service.d/http-proxy.conf
  echo "ExecStart=/usr/bin/docker daemon \$DOCKER_OPTS -H fd://" >> /etc/systemd/system/docker.service.d/http-proxy.conf
  echo "EnvironmentFile=/etc/default/docker" >> /etc/systemd/system/docker.service.d/http-proxy.conf

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
  service docker restart
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
      confSystemd
    ;;
    
  esac

fi

# ------------------------------------------------------------------------------
# Sortie propre
# ------------------------------------------------------------------------------
exit 0
