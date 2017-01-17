#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / inist-tools-dependencies.sh
#
# Installe les dépendances d'inist-tools
#
# @author : INIST-CNRS/DPI
#
################################################################################

source "/opt/inist-tools/libs/std.rc"

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

# ------------------------------------------------------------------------------
# Installation des dépendances
# ------------------------------------------------------------------------------
/opt/inist-tools/inistexec apt on
for dep in $IT_DEPENDENCIES; do
  _it_std_consoleMessage "ACTION" "Installation de « $dep »..."
  apt-get install -y "$dep"
  if [ $? == $TRUE ]; then
    _it_std_consoleMessage "CHECK" "« $dep » installé"
  else
    _it_std_consoleMessage "NOCHECK" "« $dep » est déjà installé ou n'a pas pu l'être"
  fi
done

# ------------------------------------------------------------------------------
# Fin
# ------------------------------------------------------------------------------
exit 0
