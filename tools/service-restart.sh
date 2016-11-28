#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / service-restart.sh
#
# Wrapper qui permet de redémarrer un service en arrière plan
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
# USER=$(logname)
LOCALUSER=$(who am i | awk '{print $1}' | head -1)
ID=$(which id)
# GROUP=$($ID -g -n "$LOCALUSER")
ENV_DIR="/opt/inist-tools/env"
CONF_DIR="/opt/inist-tools/conf"
SERVICE=$(which service)

# ------------------------------------------------------------------------------
# Variables locales
# ------------------------------------------------------------------------------
ServiceName="$1"

if [ -z "$ServiceName" ]; then
  _it_std_consoleMessage "ERROR" "Nom du service manquant"
  exit $FALSE
fi

# ------------------------------------------------------------------------------
# Lancement du service
# ------------------------------------------------------------------------------
$SERVICE $ServiceName restart 2>&1 >> /dev/null &

# ------------------------------------------------------------------------------
# On attend de trouver le service dans un ps pour dire qu'il est lancé...
# ------------------------------------------------------------------------------
while :
do
  ServicePIDs=$(pgrep "$ServiceName")
  if [ -z "$ServicePIDs" ]; then
    false
  else
    break
  fi
done

_it_std_message "INFO" "Le service « $ServiceName » est redémarré"

# ------------------------------------------------------------------------------
# Fin
# ------------------------------------------------------------------------------
exit 0
