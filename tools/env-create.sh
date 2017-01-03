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
