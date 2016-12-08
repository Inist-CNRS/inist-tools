#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / poweondemand.sh
#
# Mets le PC en mode "à la demande"
#
# @author : INIST-CNRS/DPI
#
################################################################################

# ------------------------------------------------------------------------------
# Ressources
# ------------------------------------------------------------------------------
source "/opt/inist-tools/libs/std.rc"
source "/opt/inist-tools/libs/ansicolors.rc"

#-------------------------------------------------------------------------------
# Environnement
#-------------------------------------------------------------------------------
MODULE_NAME="POWERONDEMAND"
MODULE_DESC="Met tous les processeur de la machine en mode à la demande."
DIR_MODULE=$(readlink -f "$CURDIR")
DIR_ROOT=$(readlink -f "$DIR_MODULE/..")
DIR_CONF=$(readlink -f "$DIR_MODULE/../conf")
DIR_LIBS=$(readlink -f "$DIR_MODULE/../libs")
DIR_TOOLS=$(readlink -f "$DIR_MODULE/../tools")
DIR_INSTALL=$(readlink -f "$DIR_MODULE/../install")
DIR_SYSINSTALL="$DIR_INSTALL/opt"

#-------------------------------------------------------------------------------
# Turboooooooo !
#-------------------------------------------------------------------------------
seq 0 7 | parallel --gnu cpufreq-set -c {} -g ondemand
