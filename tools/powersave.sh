#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / powersave.sh
#
# Mets le PC en mode économie (fréquence proc au minimum)
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
MODULE_NAME="POWERSAVE"
MODULE_DESC="Met tous les processeur de la machine en mode économie d'énergie."
DIR_MODULE=$(readlink -f "$CURDIR")
DIR_ROOT=$(readlink -f "$DIR_MODULE/..")
DIR_CONF=$(readlink -f "$DIR_MODULE/../conf")
DIR_LIBS=$(readlink -f "$DIR_MODULE/../libs")
DIR_TOOLS=$(readlink -f "$DIR_MODULE/../tools")
DIR_INSTALL=$(readlink -f "$DIR_MODULE/../install")
DIR_SYSINSTALL="$DIR_INSTALL/opt"

CORECOUNT=$(grep -c ^processor /proc/cpuinfo)

#-------------------------------------------------------------------------------
# Caaaaaaalme !
#-------------------------------------------------------------------------------
seq 0 $CORECOUNT | parallel --gnu cpufreq-set -c {} -g powersave > /dev/null 2>&1
