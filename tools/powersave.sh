#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / powersave.sh
#
# Mets le PC en mode économie (fréquence proc au max)
#
# @author : INIST-CNRS/DPI
#
################################################################################

#-------------------------------------------------------------------------------
# Environnement
#-------------------------------------------------------------------------------
MODULE_NAME="POWERSAVE"
MODULE_DESC="Met tous les processeur de la machine en mode économie d'énergie."
CURDIR=$( cd "$( dirname "$0" )" && pwd )
if [ $(which git) && $(git rev-parse) ]; then
  MODULE_VERSION=$(git describe --tags)
  MODULE_VERSION_SHORT=$(git describe --tags | cut -d"-" -f1 )
fi
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
seq 0 7 | parallel --gnu cpufreq-set -c {} -g powersave
