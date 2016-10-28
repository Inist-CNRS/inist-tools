# inist-tools #
[![Build Status](https://travis-ci.org/Inist-CNRS/inist-tools.svg?branch=master)](https://travis-ci.org/Inist-CNRS/inist-tools)
Ensemble d'outils permettant de faire fonctionner un poste GNU/Linux (Debian,
Ubuntu) dans l'environnement INIST.

## INSTALLATION ##

### Utilisateur ###

Avant toute installation, vous devez installer certaines dépendancess dont
inist-tools a besoin pour fonctionner. Il suffit de coller la commande suivante
dans une console :

```bash
$ sudo apt-get install -y make ntpdate parallel jq sudo libnotify-bin
```

Si vous êtes « utilisateur » et ne comptez pas développer inist-tools, vous
trouverez dans le répertoire /releases le paquet .deb qui vous permettra
d'installer les outils simplement avec la commande :

```bash
$ sudo dpkg -i inist-tools_x_y_z.deb
```

### .bashrc ###
Une fois l'installation terminée, pour mettre à disposition la commande inistr
dans votre environnement, ajoutez les lignes suivantes :

```bash
# INIST-TOOLS
. /opt/inist-tools/inistrc
```

### Développeur ###
Clonez le dépôt dans le répertoire de travail de votre choix.
En suite, pour faire fonctionner la commande « inist » dans l'environnement
courant, il faut configurer les éléments suivants :

### /opt ###

En tant que root, créer un lien symbolique vers le répertoire où a été cloné
inist-tools :

```bash
# cd /opt
# ln -s /chemin/vers/le/clone/de/inist-tools .
```

### .bashrc ###
*C'est le seul endroit qui permet de mettre à disposition la commande « inist »
dans les shells interactifs sans login (Konsole, Xterm, Terminator, etc.).*

Dans le .bashrc, ajouter :

```bash
# INIST-TOOLS
. /opt/inist-tools/inistrc
```

### /etc/profile.d/ ###
*Ce répertoire contient les scripts executés au lancement d'un shell interactif
avec login (tty, ssh, etc.).*

En tant que root, créer un fichier executable dans /etc/profile.d/, nommé
« inist-tools.sh » et contenant

```bash
# INIST-TOOLS
. /opt/inist-tools/inistrc
```

<div class="alert alert-success">
<strong>Configuration propres à inist-tools</strong><br />
Dans les fichiers de configuration modifiés au moment de l'installation de
inist-tools, toutles les lignes modifiées sont marquées avec
<pre># inist-tools</pre>
permettant ainsi de les retrouver et les supprimer correctement au moment de la
désinstallation du paquet.<br />
Si vous modifiez ces marquage, la désinstallation échouera et cassera le paquet
sur votre système.
</div>

### Configuration des navigateurs ###
<h3> ⚠️ En cours de refactoring ⚠️ </h3>
<strike>
Afin de permettre à vos navigateurs d'être paramétrés par inist-tools, vous
devez configurer l'utilisation du fichier

     /opt/inist-tools/proxypac.proxy.pac

comme source pour le fichier proxy.pac.

#### Chrome / Chromium ####
Normalement Chrome/Chromium utilise le proxy système. Il est possible de forcer
l'utilisation d'un fichier .pac en le lançant avec l'option

      --proxy-pac=file:///opt/inist-tools/proxypac/proxy.pac
      
#### Firefox / IceWeasel ####
Edition ➡️ Préférences ➡️ Avancé ➡️ Réseau ➡️ Connexion/Paramètres ➡️ 
Adresse de configuration automatique du proxy

     file:///opt/inist-tools/proxypac/proxy.pac
     
⚠️ Firefox ne recharge pas le fichier proxy.pac à chaque requête. Le changement
de proxy avec la commande inist proxy on|off --browsers nécessite d'utiliser
le bouton « actualiser » situé à droite du chemin vers le fichier proxy.pac.
</strike>

### Tester les commande en cours de développement ###
Du fait qu'inist-tools soit chargé au lancement, les modification faites sur le
fichier inistrc ne sont pas prises en compte avant le prochain rechargement
(nouvelle session, nouvelle console ouverte, reboot, etc.).
Pour palier cette difficulté, la commande

```bash
$ inist --reload
```
permet de recharger inistrc '"sur place" et de rendre les modifications qui lui
ont été apportées disponible immédiatement.

----

## Commandes ##

Une fois "sourcé", les commandes suivent les schémas suivants :

```bash
$ inist <service> [commande]
$ inist [-option|--option-longue]
```

##### Activer le proxy pour les services pris en charge #####

```bash
$ inist <service> [help|on|off|status]
```

```bash
  help        Informe des éventuelles particularités pour <service>
  on | off    Positionne ou supprime le proxy INIST pour le service spécifié.
  status      Indique l'état actuel du paramétrage du proxy pour le <service>
```

Par défaut, la commande inist <service> sans argument donne le statut actuel du
proxy pour le service concerné.

Les services pris en charge sont : 

    apt, bower, chrome (à venir), chromium (à venir), curl, docker,
    env (environnement système), firefox (à venir), github, gnome,
    iceweasel (à venir) ,kde, npm, ntp, shell (alias de env), unity,
    wget, xfce

#### Options ####

```bash
  -h, --help      Affiche l'aide

  -i, --info      Donne des informations sur votre configuration

  -r, --reload    Recharge inistrc pour prendre en compte les dernières
                  modifications apportées à inistrc (orienté dev)

  -s, --status    Renseigne sur l'état actuel du paramétrage du proxy INIST
                  pour l'environnement système
            
  -v,--version    Affiche la version
```

---

## DEV ##

__Note__ : <br>
*La commande « inist » devient disponible dans la console parce 
que le fichier "inistrc" est sourcé au lancement de celle-ci. Toute modification
du fichier inistrc ou des sous-commande nécessite à nouveau que le fichier
inistrc soit sourcé pour être prise en compte.<br>
Pour facilier cette opération, la commande 'inist --reload' permet de recharger
le fichier inistrc directement dans l'environnement courant.*

## Construire le package .deb ##

Depuis le répertoire du projet, executer :

```bash
$ make build
```
_Note : grâce à l'utilisation de fakeroot, il n'est plus utile de sudo la
commande._

### Tests Unitaires ###

#### Prérequis ####

Les TU utilisent :

  * shunit2
  * make 

Ces dépendances s'installent via le gestionnaire de paquet Ubuntu/Debian :

```bash
$ apt-get install -y --force-yes shunit2 build-essential
```

_Note : --force-yes n'est utile que pour les configurations Debian._

#### Lancer les tests ####

Depuis la racine du projet :

```bash
$ make test
```

Note : ne pas mettre d'exit dans les scripts des TU, sinon ils s'arrêteront
au passage sur ce fichier.

Note 2 : il est recommandé de faire les tests "proxy on" _après_ les tests
"proxy off" si on ne veut pas se retrouver avec des applis déconfigurées du
proxy INIST à la fin des tests 😁.

### Make ###
Inist-tools est fourni avec un Makefile qui permet d'automatiser un certain
nombre d'opérations. Une aide sommaire est disponible avec la commande

```bash
$ make
```
depuis le répertoire de l'application. Actuellement, le Makefile permet les
opérations suivantes :

```bash
build                          Crée le package .deb
clean                          Nettoie les scories après la création du package
install                        Installe inist-tools (non-implémenté)
release                        Build le .deb et le publie sur GitHub
test                           Lance tous les tests sur inist-tools
```

#### build ####
Construit le paquet <inist-tools_x_y_z.deb> installable sous Debian et Ubuntu
avec la commande "dpkg -i inist-tools_x_y_z.deb".

#### clean ####
Nettoie toute l'arborescence "install" des fichiers ayant servi aux commandes
'build' et 'release'.
Cette commande est utile pour ne pas avoir le projet "en double" dans l'arbo
/install et signalés par git comme n'étant pas ajoutés.

#### install ####
Installe inist-tools (non implémenté).

#### release ####
Construit le .deb et le publie sur le dépôt GitHub du projet dans /releases.

#### test ####
Lance tous les tests (unitaires et fonctionnels) du répertoire /tests.
