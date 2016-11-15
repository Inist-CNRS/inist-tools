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

#-------------------------------------------------------------------------------
# Environnement
#-------------------------------------------------------------------------------
MODULE_NAME="TIMESYNC"
MODULE_DESC="Met à jour date et heure en synchronisant au serveur de temps de l'INIST"
CURDIR=$( cd "$( dirname "$0" )" && pwd )

#-------------------------------------------------------------------------------
# Mise-à-l'heure
#-------------------------------------------------------------------------------
ntpdate ntp-int.inist.fr
