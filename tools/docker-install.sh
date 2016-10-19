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
if [ -n $debian ]; then
  platform="debian"
elif [ -n $ubuntu ]; then
  platform="ubuntu"
fi

# ------------------------------------------------------------------------------
# Quel noyaux (<3.10 pas supporté)
# ------------------------------------------------------------------------------
kernelMajor=$(uname -r | cut -d'.' -f1)
kernelMinor=$(uname -r | cut -d'.' -f2)
kernelVersion="$kernelMajor.$kernelMinor"

# Test de la version du noyau. En dessous de 3.10, pas de docker : on sort !
if [ "$kernelMajor" -lt 3 ] || [ "$kernelMinor" -lt 10 ]; then
  _it_std_consoleMessage "ERROR" "La version du noyau ($kernelVersion) ne supporte pas docker. Interruption de l'installation"
  exit $FALSE
fi

# ------------------------------------------------------------------------------
# Màj paquets
# ------------------------------------------------------------------------------
_it_std_consoleMessage "ACTION" "Màj dépôts et installation de 'apt-transport-https' et de 'ca-certificates'"
apt-get update -y 2>&1 >> /dev/null
apt-get install -y apt-transport-https ca-certificates 2>&1 >> /dev/null
if [ $? == 0 ]; then
  _it_std_consoleMessage "OK" "installation de 'apt-transport-https' et de 'ca-certificates' a réussi"
else
  _it_std_consoleMessage "NOK" "installation de 'apt-transport-https' et/ou de 'ca-certificates' échouée. Installation interrompue."
  exit $FALSE
fi

# ------------------------------------------------------------------------------
# Si c'est une Ubuntu, quelle version ?
# ------------------------------------------------------------------------------
if [ "$platform" == "ubuntu" ]; then
  ubuntuVersion=$(cat /etc/lsb-release | grep -i "DISTRIB_RELEASE" | cut -d"=" -f 2 | tr -d".")
  ubuntuMajor=$(echo "$ubuntuVersion" | cut -d"." -f 1)
  ubuntuMinor=$(echo "$ubuntuVersion" | cut -d"." -f 2)

  case "$ubuntuVersion" in
    
    "1404" )
      _it_std_consoleMessage "ACTION" "Installation des paquets du noyau..."
      sourceURL="deb https://apt.dockerproject.org/repo ubuntu-trusty main"
      apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual 2>&1 >> /dev/null
      if [ $? == 0 ]; then
        _it_std_consoleMessage "OK" "installation des paquets du noyaux a réussie"
      else
        _it_std_consoleMessage "NOK" "installation des paquets du noyaux échouée. Installation interrompue."
        exit $FALSE
      fi
    ;;
    
    "1604" )
      _it_std_consoleMessage "ACTION" "Installation des paquets du noyau..."
      sourceURL="deb https://apt.dockerproject.org/repo ubuntu-xenial main"
      apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual 2>&1 >> /dev/null
      if [ $? == 0 ]; then
        _it_std_consoleMessage "OK" "installation des paquets du noyaux réussie"
      else
        _it_std_consoleMessage "NOK" "installation des paquets du noyaux échouée. Installation interrompue."
        exit $FALSE
      fi
    ;; 

    *)
      _it_std_consoleMessage "ERROR" "Cette version d'ubuntu ($ubuntuVersion) n'est pas prise en charge"
      exit $FALSE
    ;;

  esac

fi

# ------------------------------------------------------------------------------
# Si c'est une Debian...
# ------------------------------------------------------------------------------
if [ "$platform" == "debian" ]; then

  # Installation de lsb-release si le paquet est manquant
  lsbRelease=$(which lsb_release)
  if [ -z "$lsbRelease" ]; then
    _it_std_consoleMessage "ACTION" "Installation de lsb-release..."
    apt-get install -y lsb-release 2>&1 >> /dev/null
    if [ $? == 0 ]; then
      _it_std_consoleMessage "OK" "lsb-release installé"
    else
      _it_std_consoleMessage "NOK" "lsb-relase pas installé."
      exit $FALSE
    fi
  fi

  # Détection de la version de Debian (et c'est pas du gâteau...)
  # trouvé ici : https://gist.github.com/glenbot/2890869
  debianCodename=$(cat /etc/lsb-release | grep -i "codename" | tr -d "\t" | cut -d ":" -f2)
  debianCodename=$(echo "$debianCodename" | tr '[A-Z]' '[a-z]')
  
  case "$debianCodename" in
  
    wheezy)
      echo "deb http://http.debian.net/debian wheezy-backports main" > /etc/apt/sources.list.d/backports.list
      apt-get update -y 2>&1 >> /dev/null
      sourceURL="deb https://apt.dockerproject.org/repo debian-wheezy main"
    ;;
    
    jessie)
      sourceURL="deb https://apt.dockerproject.org/repo debian-jessie main"
    ;;
    
    stretch|sid)
      sourceURL="deb https://apt.dockerproject.org/repo debian-stretch main"
    ;;
    
    *)
      _it_std_consoleMessage "ERROR" "Cette version ($debianCodename) de Debian n'est pas prise en charge. Interruption de l'installation."
      exit $FALSE
    ;;
    
  esac
  # sourceURL="deb http://http.debian.net/debian wheezy-backports main"
fi

# ------------------------------------------------------------------------------
# Clés
# ------------------------------------------------------------------------------
/opt/inist-tools/inistexec env on
_it_std_consoleMessage "ACTION" "Ajout de la clef publiques du dépôt docker..."
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
if [ $? == 0 ]; then
  _it_std_consoleMessage "INFO" "Clef publique pour le dépôt 'docker' installée"
else
  _it_std_consoleMessage "ERROR" "Impossible d'installer la clef publique pour le dépôt 'docker'. Installation interrompue."
  exit $FALSE
fi

# ------------------------------------------------------------------------------
# Fichier APT docker.list
# ------------------------------------------------------------------------------
_it_std_consoleMessage "ACTION" "Fichier '$dockerSourceList'"
cat "$sourceURL" > "$dockerSourceList"
if [ $? == 0 ]; then
  _it_std_consoleMessage "OK" "créé"
else
  _it_std_consoleMessage "NOK" "échoué. Installation interrompue."
  exit $FALSE
fi

# ------------------------------------------------------------------------------
# Install de Docker proprement-dit
# ------------------------------------------------------------------------------
_it_std_consoleMessage "ACTION" "Installation de docker..."
apt-get update -y 2>&1 >> /dev/null
apt-get purge -y "lxc-docker*" 2>&1 >> /dev/null
apt-get purge "docker.io*" 2>&1 >> /dev/null
apt-cache policy docker-engine 2>&1 >> /dev/null
apt-get update -y 2>&1 >> /dev/null
apt-get install -y docker-engine 2>&1 >> /dev/null
if [ $? == 0 ]; then
  _it_std_consoleMessage "OK" "installation des paquets du noyau réussie"
else
  _it_std_consoleMessage "NOK" "installation des paquets du noyau échouée. Installation interrompue."
  exit $FALSE
fi

# ------------------------------------------------------------------------------
# Lancement du service...
# ------------------------------------------------------------------------------
_it_std_consoleMessage "ACTION" "Lancement du service docker..."
service docker start 2>&1 >> /dev/null
if [ $? == 0 ]; then
  _it_std_consoleMessage "OK" "service lancé"
else
  _it_std_consoleMessage "NOK" "impossible de lancer le service. Installation interrompue."
  exit $FALSE
fi

# ------------------------------------------------------------------------------
# Ajout de l'utilisateur courant au groupe Docker
# ------------------------------------------------------------------------------
_it_std_consoleMessage "ACTION" "Création du groupe docker..."
groupadd docker
if [ $? == 0 ]; then
  _it_std_consoleMessage "OK" "usergroup 'docker' créé avec succès"
else
  _it_std_consoleMessage "NOK" "impossible de créer le usergroup 'docker'. Installation interrompue."
  exit $FALSE
fi

_it_std_consoleMessage "ACTION" "Ajout de '$USER' au groupe docker"
usermod -aG docker "$USER"
if [ $? == 0 ]; then
  _it_std_consoleMessage "OK" "$USER ajouté au usergroup 'docker' avec succès"
else
  _it_std_consoleMessage "NOK" "impossible d'ajouter '$USER' au usergroup 'docker'. Installation interrompue."
  exit $FALSE
fi

_it_std_consoleMessage "WARNING" "N'oubliez pas de vous déloguer/reloguer pour que les modifications prennent effet"

# ------------------------------------------------------------------------------
# ReLancement du service...
# ------------------------------------------------------------------------------
_it_std_consoleMessage "ACTION" "ReLancement du service docker..."
service docker restart 2>&1 >> /dev/null
if [ $? == 0 ]; then
  _it_std_consoleMessage "OK" "service relancé"
else
  _it_std_consoleMessage "NOK" "impossible de relancer le service. Installation interrompue."
  exit $FALSE
fi

# ------------------------------------------------------------------------------
# Installation de Docker-Compose
# ------------------------------------------------------------------------------
# On fait en sorte de pouvoir "sortir" de l'INIST ave curl... (et comme on est
# root durant l'installation, on passe par inistexec...)
/opt/inist-tools/inistexec curl on

_it_std_consoleMessage "ACTION" "Téléchargement de docker-compose..."
curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
if [ $? == 0 ]; then
  _it_std_consoleMessage "OK" "docker-compose téléchargé"
else
  _it_std_consoleMessage "NOK" "impossible de télécharger docker-compose. Vérifiez vos paramètres réseau (proxy)."
  exit $FALSE
fi

_it_std_consoleMessage "ACTION" "Rendre docker-compose executable..."
if [ -a /usr/local/bin/docker-compose ]; then
  chmod +x /usr/local/bin/docker-compose
  if [ $? == 0 ]; then
    _it_std_consoleMessage "OK" "docker-compose chmodé pluzix avec succès"
  else
    _it_std_consoleMessage "NOK" "impossible de chmoder docker-compose. Installation interrompue."
    exit $FALSE
  fi
else
  _it_std_consoleMessage "NOK" "Fichier '/usr/local/bin/docker-compose' introuvable. A-t-il été correctement téléchargé ? Installation interrompue."
  exit $FALSE
fi

# ------------------------------------------------------------------------------
# Vérification de la version de docker-compose (== est bien installé)
# ------------------------------------------------------------------------------
_it_std_consoleMessage "ACTION" "Vérification de l'installation de docker-compose..."
docker-compose --version 2>&1 >> /dev/null
if [ $? == 0 ]; then
  dcVersion=$(docker-compose --version)
  _it_std_consoleMessage "OK" "docker-compose installé en version $dcVersion"
else
  _it_std_consoleMessage "NOK" "installation échouée"
  exit $FALSE
fi
