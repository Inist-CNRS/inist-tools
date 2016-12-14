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
case "$HOST_SYSTEM" in

  ubuntu)
    case "$HOST_SYSTEM_VERSION" in
    
      "12.04" | "12.10" | "13.04" | "13.10" | "14.04" | "14.10" )
        $SERVICE $ServiceName restart > /dev/null 2>&1
      ;;
      
      *)
        systemctl daemon-reload > /dev/null 2>&1
        sleep 1
        systemctl restart "$ServiceName" > /dev/null 2>&1
      ;;
    esac
  ;;
  
  debian)
    systemctl daemon-reload > /dev/null 2>&1 
    sleep 1
    systemctl restart "$ServiceName" > /dev/null 2>&1
  ;;
  
  *)
    _it_std_consoleMessage "ERROR" "Je ne sais pas comment redémarrer « $ServiceName » sur ce système !"
    exit $FALSE
  ;;
  
esac

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

notify-send --expire-time=1500 --icon="/opt/inist-tools/libs/gfx/cnrs_64px.png" --urgency=low "INFORMATION" "Le service « $ServiceName » est redémarré"

# ------------------------------------------------------------------------------
# Fin
# ------------------------------------------------------------------------------
exit 0
