#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / inist-tools-update.sh
#
#
# @author : INIST-CNRS/DPI
#
################################################################################

# ------------------------------------------------------------------------------
# Variables globales
# ------------------------------------------------------------------------------
export PATH="$PATH:/opt/inist-tools"
PID="$$"
PARENT_COMMAND="$(ps -o comm= $PPID)"
MODULE_NAME="INIST-TOOLS"
DIR_MODULE="/opt/inist-tools" # fixé "en dur" en fonction du chemin définitif
DIR_CONF="$DIR_MODULE/conf"
DIR_LIBS="$DIR_MODULE/libs"
DIR_TOOLS="$DIR_MODULE/tools"
DIR_INSTALL="$DIR_MODULE/install"
DIR_ENV="$DIR_MODULE/env"

#-------------------------------------------------------------------------------
# 
#-------------------------------------------------------------------------------
IT_LATEST="/tmp/inist-tools_latest.deb"
if [ -f "$IT_LATEST" ]; then
  rm "$IT_LATEST"
fi
# On active le proxy pour wget
/opt/inist-tools/inistexec wget on
# Téléchargement de la latest
wget -O "$IT_LATEST" "https://github.com/Inist-CNRS/inist-tools/raw/master/releases/inist-tools_latest.deb"
# Installation
dpkgi -i "$IT_LATEST"

# ------------------------------------------------------------------------------
# Fin
# ------------------------------------------------------------------------------
exit 0
