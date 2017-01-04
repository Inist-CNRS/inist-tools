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
else
  DOCKER_OPTS_CUSTOM=""
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


# ------------------------------------------------------------------------------
# Service
# ------------------------------------------------------------------------------
case "$HOST_SYSTEM" in

  debian)
    # Modification de la conf
    mkdir -p "$INIST_TOOLS_CONF_DIR"
    
    if [ -a "$INIST_TOOLS_CONF_FILE" ]; then
      rm "$INIST_TOOLS_CONF_FILE"
    fi
    
    touch "$INIST_TOOLS_CONF_FILE"
    
    echo "# inist-tools" >> "$INIST_TOOLS_CONF_FILE"
    echo "[Service]" >> "$INIST_TOOLS_CONF_FILE"
    echo "ExecStart=" >> "$INIST_TOOLS_CONF_FILE"
    echo "ExecStart=/usr/bin/docker daemon \$DOCKER_OPTS -H fd://" >> "$INIST_TOOLS_CONF_FILE"
    echo "EnvironmentFile=/etc/default/docker" >> "$INIST_TOOLS_CONF_FILE"

    # Prise en charge de la conf et redémarrage du service
    /opt/inist-tools/tools/service-restart.sh "docker" &
  ;;
  
  ubuntu)
    /opt/inist-tools/tools/service-restart.sh "docker" &
    
    case "$HOST_SYSTEM_VERSION" in
    
      "12.04" | "12.10" | "13.04" | "13.10" | "14.04" | "14.10" )
        #/opt/inist-tools/tools/service-restart.sh "docker" &
      ;;
      
      *)
        # Modification de la conf
        mkdir -p "$INIST_TOOLS_CONF_DIR"
        
        if [ -a "$INIST_TOOLS_CONF_FILE" ]; then
          rm "$INIST_TOOLS_CONF_FILE"
        fi
        
        touch "$INIST_TOOLS_CONF_FILE"
        
        echo "# inist-tools" >> "$INIST_TOOLS_CONF_FILE"
        echo "[Service]" >> "$INIST_TOOLS_CONF_FILE"
        echo "ExecStart=" >> "$INIST_TOOLS_CONF_FILE"
        echo "ExecStart=/usr/bin/docker daemon \$DOCKER_OPTS -H fd://" >> "$INIST_TOOLS_CONF_FILE"
        echo "EnvironmentFile=/etc/default/docker" >> "$INIST_TOOLS_CONF_FILE"

        # Prise en charge de la conf et redémarrage du service
        /opt/inist-tools/tools/service-restart.sh "docker" &

      ;;
      
    esac
  ;;
  
esac

# ------------------------------------------------------------------------------
# Sortie propre
# ------------------------------------------------------------------------------
exit 0
