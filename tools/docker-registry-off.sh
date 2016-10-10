#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / docker-registry-off.sh
# 
# Sous-routine qui supprime le registry INIST pour DOCKER
#
# /!\ S'execute en ROOT
#
# @author : INIST-CNRS/DPI
#
###############################################################################

# ------------------------------------------------------------------------------
# Variables globales
# ------------------------------------------------------------------------------
DOCKER_DEFAULT_FILE="/etc/default/docker"
INIST_CERT_FILE="/etc/docker/certs.d/vsregistry.intra.inist.fr:5000/ca.crt"

rm -Rf "$INIST_CERT_FILE"

