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
MODULE_VERSION=$(git describe --tags)
MODULE_VERSION_SHORT=$(git describe --tags | cut -d"-" -f1 )
CURDIR=$( cd "$( dirname "$0" )" && pwd )
DIR_MODULE=$(readlink -f "$CURDIR")
DIR_ROOT=$(readlink -f "$DIR_MODULE/..")
DIR_CONF=$(readlink -f "$DIR_MODULE/../conf")
DIR_LIBS=$(readlink -f "$DIR_MODULE/../libs")
DIR_TOOLS=$(readlink -f "$DIR_MODULE/../tools")
DIR_INSTALL=$(readlink -f "$DIR_MODULE/../install")
DIR_SYSINSTALL="$DIR_INSTALL/opt"

#-------------------------------------------------------------------------------
# Mise-à-l'heure
#-------------------------------------------------------------------------------
ntpdate ntp-int.inist.fr
