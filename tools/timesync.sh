#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / timesync.sh
#
# Met à l'heure le PC en synchronisant au serveur de temps de l'INIST
#
# @author : INIST-CNRS/DPI
#
################################################################################

source "/opt/inist-tools/libs/std.rc"
source "/opt/inist-tools/libs/ansicolors.rc"

#-------------------------------------------------------------------------------
# Environnement
#-------------------------------------------------------------------------------
MODULE_NAME="TIMESYNC"
MODULE_DESC="Met à jour date et heure en synchronisant au serveur de temps de l'INIST"
CURDIR=$( cd "$( dirname "$0" )" && pwd )

#-------------------------------------------------------------------------------
# Mise-à-l'heure
#-------------------------------------------------------------------------------
if which ntpd ; then
  _it_std_consoleMessage "WARNING" "ntpd est déjà utilisé pour sdynchroniser la machine"
  exit $TRUE
else
  if _it_std_check_command "ntpdate" ; then
    ntpdate ntp-int.inist.fr > /dev/null 2>&1
  else
    _it_std_consoleMessage "ERROR" "ntpdate n'est pas installé sur votre machine. Essayez 'inist dependencies install'."
    exit $FALSE
  fi
fi

#-------------------------------------------------------------------------------
# Fin
#-------------------------------------------------------------------------------
exit $TRUE
