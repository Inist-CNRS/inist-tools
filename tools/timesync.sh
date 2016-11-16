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
  _it_std_consoleMessage "INFO" "ntpd est déjà utilisé pour sdynchroniser la machine"
else
  ntpdate ntp-int.inist.fr
fi

#-------------------------------------------------------------------------------
# Fin
#-------------------------------------------------------------------------------
exit 0
