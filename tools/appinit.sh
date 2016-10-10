#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / app-init.sh
#
# Prépare le système à fonctionner avec INIST-TOOLS
#
# @author : INIST-CNRS/DPI
#
################################################################################

# ------------------------------------------------------------------------------
# Variables globales
# ------------------------------------------------------------------------------
USER=$(logname)

# ------------------------------------------------------------------------------
# /var/run sert à stocker l'état de fonctionnement d'inist-tools
# ------------------------------------------------------------------------------
mkdir -p /var/run/inist-tools
chown -R "$USER:$USER" /var/run/inist-tools
chmod -R 755 /var/run/inist-tools
