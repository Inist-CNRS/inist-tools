#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / powermax.sh
#
# Mets le PC en mode "à donf" (fréquence proc au max)
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
MODULE_NAME="POWERMAX"
MODULE_DESC="Met tous les processeur de la machine en mode « performance »."
DIR_MODULE=$(readlink -f "$CURDIR")
DIR_ROOT=$(readlink -f "$DIR_MODULE/..")
DIR_CONF=$(readlink -f "$DIR_MODULE/../conf")
DIR_LIBS=$(readlink -f "$DIR_MODULE/../libs")
DIR_TOOLS=$(readlink -f "$DIR_MODULE/../tools")
DIR_INSTALL=$(readlink -f "$DIR_MODULE/../install")
DIR_SYSINSTALL="$DIR_INSTALL/opt"

CORECOUNT=$(grep -c ^processor /proc/cpuinfo)

#-------------------------------------------------------------------------------
# Turboooooooo !
#-------------------------------------------------------------------------------
seq 0 $CORECOUNT | parallel --gnu cpufreq-set -c {} -g performance > /dev/null 2>&1
