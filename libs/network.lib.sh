#!/usr/bin/env bash
########################################################################
#
# INIST-TOOLS / NETWORK
# 
# Bibliothèque de fonctions réseau
#
# @author : INIST-CNRS/DPI
#
########################################################################

#-----------------------------------------------------------------------
# Initialisation de variables globales
#-----------------------------------------------------------------------


#-----------------------------------------------------------------------
# Vérification de la connectivite internet
# 0 -> connexion filaire INIST
# 1 -> connexion autre
#-----------------------------------------------------------------------
function _it_network_isInistNetwork {
  # En fonction des distrib, ifconfig n'est pas toujours au même endroit...
  local ifc=$(which ifconfig)
  # On cherche l'IP "type INIST" (mais c'est une plage privée qu'on peut retrouver ailleurs)
  local COUNT=$("$ifc" | grep -i "172.16")
  # On ping vanda (si ça répond pas, c'est qu'on est pas en filaire INIST)
  VANDA=$(ping -c 1 vanda.ads.intra.inist.fr | grep -i "unknown")
  if [ "$COUNT" ] && [ ! $VANDA ]; then
    IS_INIST=0
    return 0
  else
    IS_INIST=1
    return 1
  fi
}

#-----------------------------------------------------------------------
# Positionne les variables d'environnement pour le proxy INIST
#-----------------------------------------------------------------------
function _it_network_inistProxySet {
  # Message
  printf "Positionnement des variables d'environnement pour le proxy INIST\n"
  
  # Exclusion du proxy
  export no_proxy="localhost,127.0.0.0/8,*.local,172.16.0.0/16"
  export NO_PROXY="localhost,127.0.0.0/8,*.local,172.16.0.0/16"

  # HTTP
  export http_proxy="http://proxyout.inist.fr:8080"
  export HTTP_PROXY="http://proxyout.inist.fr:8080"

  # HTTPS
  export https_proxy="http://proxyout.inist.fr:8080"
  export HTTPS_PROXY="http://proxyout.inist.fr:8080"

  # FTP
  export ftp_proxy="http://proxyout.inist.fr:8080"
  export FTP_PROXY="http://proxyout.inist.fr:8080"
  
  # On affiche le résultat dans l'environnement
  env | grep -i "proxy"
}

#-----------------------------------------------------------------------
# Reset les variables d'environnement proxy
#-----------------------------------------------------------------------
function _it_network_inistProxyUnset {
  # Message
  printf "Suppression des variables d'environnement pour le proxy INIST\n"

  unset "no_proxy"
  unset "http_proxy"
  unset "https_proxy"
  unset "ftp_proxy"

  unset "NO_PROXY"
  unset "HTTP_PROXY"
  unset "HTTPS_PROXY"
  unset "FTP_PROXY"
  
  # Affichage du résultat (normalement il ne devrait rien y avoir... normalement...)
  env | grep -i "proxy"
}

#-----------------------------------------------------------------------
# Informations Réseau
#-----------------------------------------------------------------------
function _it_network_info {
  # Combien d'interfaces filaires ?
  INFO_NET_ETH_COUNT=$(ifconfig -s | grep -i "eth" | wc -l)
  # Combien d'interfaces WiFi ?
  INFO_NET_WLAN_COUNT=$(ifconfig -s | grep -i "wlan" | wc -l)
  # INIST ou pas INIST ?
  if _it_network_isInistNetwork ; then
    INFO_NET_INIST="INIST"
  else
    INFO_NET_INIST="en mobilité"
  fi
  # Wifi ou filaire ?
  if $(ifconfig | grep -i "wlan") ; then
    INFO_NET_TYPE="wifi"
  else
    INFO_NET_TYPE="ethernet"
  fi

  # Adresse IP
  INFO_NET_IP=$(hostname  -I | cut -f1 -d' ')


  # Affichage des infos
  printf "\n"
  printf "Général\n"

  printf "\n"
  printf "Informations Réseau\n"
  printf "Interface(s) ETH active(s)  :\t$INFO_NET_ETH_COUNT\n"
  printf "Interface(s) WIFI active(s) :\t$INFO_NET_WLAN_COUNT\n"
  printf "Réseau en cours             :\t$INFO_NET_TYPE\n"
  printf "Adresse IP                  :\t$INFO_NET_IP\n"
  printf "Réseau utilisé              :\t$INFO_NET_INIST\n"

  printf "\n"
  printf "Environnement\n"
  printf "Utilisateur courant     : $USER\n"
  printf "Répertoire d'exectution : $CURDIR\n"
}
