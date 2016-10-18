#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / docker-install.sh
# 
# Sous-routine qui installe proprement DOCKER sous Ubuntu et Debian
#
# /!\ S'execute en ROOT
#
# @author : INIST-CNRS/DPI
#
################################################################################

source "/opt/inist-tools/libs/std.rc"
source "/opt/inist-tools/libs/ansicolors.rc"

# ------------------------------------------------------------------------------
# Variables globales
# ------------------------------------------------------------------------------
dockerSourceList="/etc/apt/sources.list.d/docker.list"
USER=$(logname)

# ------------------------------------------------------------------------------
# Quel Linux ?
# ------------------------------------------------------------------------------
is_debian=$(cat /etc/issue | grep -i "debian")
is_ubuntu=$(cat /etc/issue | grep -i "ubuntu")

# ------------------------------------------------------------------------------
# Màj paquets
# ------------------------------------------------------------------------------
_it_std_consoleMessage "INFO" "Màj dépôts et installation de 'apt-transport-https' et de 'ca-certificates'"
apt-get update -y 2>&1 >> /dev/null
apt-get install -y apt-transport-https ca-certificates 2>&1 >> /dev/null
if [ $? == 0 ]; then
  _it_std_consoleMessage "OK" "L'installation de 'apt-transport-https' et de 'ca-certificates' a réussi"
else
  _it_std_consoleMessage "NOK" "L'installation de 'apt-transport-https' et de 'ca-certificates' a échoué. Installation interrompue."
  return $FALSE
fi

# ------------------------------------------------------------------------------
# Si c'est une Ubuntu, quelle version ?
# ------------------------------------------------------------------------------
if [ is_ubuntu ]; then
  ubuntuVersion=$(cat /etc/lsb-release | grep -i "DISTRIB_RELEASE" | cut -d"=" -f 2)
  ubuntuMajor=$(echo "$ubuntuVersion" | cut -d"." -f 1)
  ubuntuMinor=$(echo "$ubuntuVersion" | cut -d"." -f 2)

  case "$ubuntuVersion"
    
    "14.04")
      _it_std_consoleMessage "INFO" "Installation des paquets du noyau..."
      sourceURL="deb https://apt.dockerproject.org/repo ubuntu-trusty main"
      apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual 2>&1 >> /dev/null
      if [ $? == 0 ]; then
        _it_std_consoleMessage "OK" "L'installation des paquets du noyaux a réussi"
      else
        _it_std_consoleMessage "NOK" "L'installation des paquets du noyaux a échoué. Installation interrompue."
        return $FALSE
      fi
    ;;
    
    "16.04")
      _it_std_consoleMessage "INFO" "Installation des paquets du noyau..."
      sourceURL="deb https://apt.dockerproject.org/repo ubuntu-xenial main"
      apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual 2>&1 >> /dev/null
      if [ $? == 0 ]; then
        _it_std_consoleMessage "OK" "L'installation des paquets du noyaux a réussi"
      else
        _it_std_consoleMessage "NOK" "L'installation des paquets du noyaux a échoué. Installation interrompue."
        return $FALSE
      fi
    ;; 

    *)
      _it_std_consoleMessage "ERROR" "Cette version d'ubuntu ($ubuntuVersion) n'est pas prise en charge"
      return $FALSE
    ;;

  esac

fi

# ------------------------------------------------------------------------------
# Si c'est une Debian...
# ------------------------------------------------------------------------------
if [ is_debian ]; then
  
  # sourceURL="deb http://http.debian.net/debian wheezy-backports main"
fi

# ------------------------------------------------------------------------------
# Clés
# ------------------------------------------------------------------------------
_it_std_consoleMessage "INFO" "Ajout de la clef publiques du dépôt docker..."
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
if [ $? == 0 ]; then
  _it_std_consoleMessage "INFO" "Clef publique pour le dépôt 'docker' installée"
else
  _it_std_consoleMessage "ERROR" "Impossible d'installée la clef publique pour le dépôt 'docker'. Installation interrompue."
  return $FALSE
fi

# ------------------------------------------------------------------------------
# Fichier APT docker.list
# ------------------------------------------------------------------------------
if [ -a "$dockerSourceList" ]; then
  _it_std_consoleMessage "INFO" "Fichier '$dockerSourceList' trouvé, on le supprime"
  rm "$dockerSourceList"
  _it_std_consoleMessage "INFO" "Fichier '$dockerSourceList' créé et mis-à-jour"
  cat "$sourceURL" > "$dockerSourceList"
fi

# ------------------------------------------------------------------------------
# Install de Docker proprement-dit
# ------------------------------------------------------------------------------
_it_std_consoleMessage "INFO" "Installation de docker..."
apt-get update -y 2>&1 >> /dev/null
apt-get purge -y "lxc-docker*" 2>&1 >> /dev/null
apt-get purge "docker.io*" 2>&1 >> /dev/null
apt-cache policy docker-engine 2>&1 >> /dev/null
apt-get update -y 2>&1 >> /dev/null
apt-get install -y docker-engine 2>&1 >> /dev/null
if [ $? == 0 ]; then
  _it_std_consoleMessage "OK" "L'installation des paquets du noyaux a réussi"
else
  _it_std_consoleMessage "NOK" "L'installation des paquets du noyaux a échoué. Installation interrompue."
  return $FALSE
fi

# ------------------------------------------------------------------------------
# Lancement du service...
# ------------------------------------------------------------------------------
_it_std_consoleMessage "INFO" "Lancement du service docker..."
service docker start 2>&1 >> /dev/null
if [ $? == 0 ]; then
  _it_std_consoleMessage "OK" "Service lancé"
else
  _it_std_consoleMessage "NOK" "Impossible de lancer le service. Installation interrompue."
  return $FALSE
fi

# ------------------------------------------------------------------------------
# Ajout de l'utilisateur courant au groupe Docker
# ------------------------------------------------------------------------------
_it_std_consoleMessage "INFO" "Création du groupe docker..."
groupadd docker
if [ $? == 0 ]; then
  _it_std_consoleMessage "OK" "Usergroup 'docker' créé avec succès"
else
  _it_std_consoleMessage "NOK" "Impossible de créer le usergroup 'docker'. Installation interrompue."
  return $FALSE
fi

_it_std_consoleMessage "INFO" "Ajout de '$USER' au groupe docker"
usermod -aG docker "$USER"
if [ $? == 0 ]; then
  _it_std_consoleMessage "OK" "$USER ajouté au usergroup 'docker' avec succès"
else
  _it_std_consoleMessage "NOK" "Impossible d'ajouter '$USER' au usergroup 'docker'. Installation interrompue."
  return $FALSE
fi

_it_std_consoleMessage "WARNING" "N'oubliez pas de vous déloguer/reloguer pour que les modifications prennent effet"

# ------------------------------------------------------------------------------
# Installation de Docker-Compose
# ------------------------------------------------------------------------------
inist curl on
_it_std_consoleMessage "INFO" "Téléchargement de docker-compose"
curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
_it_std_consoleMessage "INFO" "Docker-compose executable"
if [ -a /usr/local/bin/docker-compose ]; then
  chmod +x /usr/local/bin/docker-compose
  if [ $? == 0 ]; then
    _it_std_consoleMessage "OK" "docker-compose chmodé pluzix avec succès"
  else
    _it_std_consoleMessage "NOK" "Impossible de chmoder docker-compose. Installation interrompue."
    return $FALSE
  fi
else
  _it_std_consoleMessage "NOK" "Fichier '' introuvable. A-t-il été correctement téléchargé ? Installation interrompue."
  return $FALSE
fi

# ------------------------------------------------------------------------------
# Vérification de la version de docker-compose (== est bien installé)
# ------------------------------------------------------------------------------
docker-compose --version 2>&1 >> /dev/null
if [ $? == 0 ]; then
  dcVersion=$(docker-compose --version)
  _it_std_consoleMessage "OK" "docker-compose vient d'être installé en version $dcVersion"
else
  _it_std_consoleMessage "NOK" "L'installation de docker-compose a échoué"
  return $FALSE
fi
