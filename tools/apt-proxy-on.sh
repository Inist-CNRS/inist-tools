#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / apt-proxy-on.sh
# 
# Sous-routine qui positionne le proxy inist pour APT
#
# /!\ S'execute en ROOT
#
# @author : INIST-CNRS/DPI
#
################################################################################

# ------------------------------------------------------------------------------
# Variables globales
# ------------------------------------------------------------------------------
APT_PROXIES_FILE="/etc/apt/apt.conf.d/95proxies"

# PROXY
INIST_HTTP_PROXY="http://proxyout.inist.fr:8080"
INIST_HTTPS_PROXY="https://proxyout.inist.fr:8080"
INIST_FTP_PROXY="http://proxyout.inist.fr:8080"
INIST_PROXYPAC="http://proxypac.intra.inist.fr/proxy.pac"
INIST_NO_PROXY="localhost,127.0.0.0/8,*.local,172.16.0.0/16"
INIST_PROXY_ADDRESS="http://proxyout.inist.fr"
INIST_PROXY_PORT="8080"

# ------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------
# Si le fichier 95proxies existe déjà, on le supprime
if [ -f "$APT_PROXIES_FILE" ]; then
  rm "$APT_PROXIES_FILE"
fi

touch "$APT_PROXIES_FILE" 2>&1 >> /dev/null
printf "Acquire::http::proxy \"$INIST_HTTP_PROXY/\";\n" >> "$APT_PROXIES_FILE" 2>&1
printf "Acquire::https::proxy \"$INIST_HTTPS_PROXY/\";\n" >> "$APT_PROXIES_FILE" 2>&1
printf "Acquire::ftp::proxy \"$INIST_FTP_PROXY/\";\n" >> "$APT_PROXIES_FILE" 2>&1
# printf "\n" >> "$APT_PROXIES_FILE" 2>&1

# ------------------------------------------------------------------------------
# Sortie propre
# ------------------------------------------------------------------------------
exit 0
