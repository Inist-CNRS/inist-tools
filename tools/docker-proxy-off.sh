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
# Variables globales
# ------------------------------------------------------------------------------
DOCKER_DEFAULT_FILE="/etc/default/docker"
INIST_TOOLS_CONF_DIR="/etc/systemd/system/docker.service.d"
INIST_TOOLS_CONF_FILE="$INIST_TOOLS_CONF_DIR/inist-tools.conf"
TMPFILE="/run/shm/tmpfile$$"

# ------------------------------------------------------------------------------
# Nettoyage du default file pour docker des références au proxy INIST
# ------------------------------------------------------------------------------
grep -vi "inist\.fr" "$DOCKER_DEFAULT_FILE" | tr -s '\n' > "$TMPFILE"
cp "$TMPFILE" "$DOCKER_DEFAULT_FILE"
rm "$TMPFILE"

# ------------------------------------------------------------------------------
# Service
# ------------------------------------------------------------------------------

case "$HOST_SYSTEM" in

  debian)
    # Suppression du fichier de conf spécifique INIST
    rm "$INIST_TOOLS_CONF_FILE"
    # Redémarrage du service docker
    /opt/inist-tools/tools/service-restart.sh "docker" &
  ;;
  
  ubuntu)
    # Modification du fichier de confi 
    echo "ExecStart=/usr/bin/docker daemon \$DOCKER_OPTS -H fd://" >> "$INIST_TOOLS_CONF_FILE"
    # Redémarrage du service docker
    /opt/inist-tools/tools/service-restart.sh "docker" &
  ;;
  
esac

# ------------------------------------------------------------------------------
# Sortie propre
# ------------------------------------------------------------------------------
exit 0
