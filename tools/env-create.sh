#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / env-create.sh
#
# Créé le répertoire de stockage des variables d'environnement persistantes
# Permet la modifiction par l'utilisateur des fichiers de configuration
#
# Doit être appellé depuis /opt/inist-tools/inistrc -> dépendance des vars
# USER_LOGIN et USER_GROUP
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
# Utilisateur + Groupe passés en argument du script
#-------------------------------------------------------------------------------
if [ ! -z "$1" ]; then
  USER_LOGIN="$1"
else
  exit 1
fi

if [ ! -z "$2" ]; then
  USER_GROUP="$2"
else
  exit 1
fi

if [ "$USER_LOGIN" == "root" ]; then
  exit 1
fi

# ------------------------------------------------------------------------------
# Répertoire d'environnement
# ------------------------------------------------------------------------------
if [ ! -d "$DIR_ENV" ]; then
  mkdir -p "$DIR_ENV"
fi
chown -R "$USER_LOGIN":"$USER_GROUP" "$DIR_ENV"
chmod -R 777 "$DIR_ENV"

# ------------------------------------------------------------------------------
# Répertoire de configuration
# ------------------------------------------------------------------------------
chown -R "$USER_LOGIN":"$USER_GROUP" "$DIR_CONF"
chmod -R 755 "$DIR_CONF"

# ------------------------------------------------------------------------------
# Fin
# ------------------------------------------------------------------------------
exit 0
