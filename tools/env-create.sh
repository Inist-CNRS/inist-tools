#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / env-create.sh
#
# Créé le répertoire de stockage des variables d'environnement persistantes
# Permet la modifiction par l'utilisateur des fichiers de configuration
#
# @author : INIST-CNRS/DPI
#
################################################################################

# ------------------------------------------------------------------------------
# Variables globales
# ------------------------------------------------------------------------------
# USER=$(logname)
USER=$(who am i | awk '{print $1}' | head -1)
GROUP=$(id -g -n "$USER")
ENV_DIR="/opt/inist-tools/env"
CONF_DIR="/opt/inist-tools/conf"

# ------------------------------------------------------------------------------
# Répertoire d'environnement
# ------------------------------------------------------------------------------
if [ ! -d "$ENV_DIR" ]; then
  mkdir -p "$ENV_DIR"
  # chown -R "$USER":"$USER" "$ENV_DIR"
  chown -R "$USER":"$GROUP" "$ENV_DIR"
  chmod -R 777 "$ENV_DIR"
fi

# ------------------------------------------------------------------------------
# Répertoire de configuration
# ------------------------------------------------------------------------------
chown -R "$USER":"$GROUP" "$CONF_DIR"
chmod -R 755 "$CONF_DIR"

# ------------------------------------------------------------------------------
# Fin
# ------------------------------------------------------------------------------
exit 0
