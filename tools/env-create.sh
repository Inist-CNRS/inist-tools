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
# Utilisateur + Groupe -> environnement pour réutilisation en sudo
#-------------------------------------------------------------------------------
USER_LOGIN=$(who am i | awk '{print $1}' | head -1)
if [ -z "$USER_LOGIN" ]; then
  USER_LOGIN=$(echo $USER);
fi
ID=$(which id)
USER_GROUP=$($ID -g -n "$USER_LOGIN")

# ------------------------------------------------------------------------------
# Répertoire d'environnement
# ------------------------------------------------------------------------------
if [ ! -d "$DIR_ENV" ]; then
  mkdir -p "$DIR_ENV"
  # chown -R "$USER":"$USER" "$ENV_DIR"
  chown -R "$USER_LOGIN":"$USER_GROUP" "$DIR_ENV"
  chmod -R 777 "$DIR_ENV"
fi

# ------------------------------------------------------------------------------
# Répertoire de configuration
# ------------------------------------------------------------------------------
chown -R "$USER":"$GROUP" "$DIR_CONF"
chmod -R 755 "$DIR_CONF"

# ------------------------------------------------------------------------------
# Fin
# ------------------------------------------------------------------------------
exit 0
