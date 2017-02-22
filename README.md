# inist-tools #
[![Build Status](https://travis-ci.org/Inist-CNRS/inist-tools.svg?branch=master)](https://travis-ci.org/Inist-CNRS/inist-tools)
Ensemble d'outils permettant de faire fonctionner un poste GNU/Linux (Debian,
Ubuntu) dans l'environnement INIST.

## INSTALLATION ##

### Utilisateur ###

Avant toute installation, vous devez installer certaines dépendancess dont
inist-tools a besoin pour fonctionner. Il suffit de coller en tant que root la commande suivante
dans une console :

```bash
$ apt-get install -y make ntpdate parallel jq sudo libnotify-bin
```

Si vous êtes « utilisateur » et ne comptez pas développer inist-tools, vous
trouverez dans le répertoire [/releases](https://github.com/Inist-CNRS/inist-tools/tree/master/releases) le paquet .deb qui vous permettra d'installer les outils simplement avec la commande :

```bash
$ sudo dpkg -i inist-tools_x_y_z.deb
```
Pour accéder directement à la dernière release, [vous pouvez suivre ce lien](https://github.com/Inist-CNRS/inist-tools/raw/master/releases/inist-tools_latest.deb).

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
Du fait de la diversité des configuration des navigateurs et de l'impossibilité
de les unifier, inist-tools ne prend pas en charge le proxy pour les navigateurs
web.

Vous pouvez explorer les pistes suivantes pour gérer le proxy dans vos
navigateurs :

#### FireFox (IceWeasel) ####
[Proxy Switcher *(cliquer ici depuis FireFox/IceWeasel)*](https://addons.mozilla.org/firefox/downloads/latest/proxy-switcher/addon-654096-latest.xpi?src=dp-btn-primary)

*Configurez le plugin de cette manière :*

![webproxy_firefox_01](https://cloud.githubusercontent.com/assets/6779966/21498903/3c7bdc76-cc31-11e6-821d-8c9629cd4042.png)

*En cliquant sur « edit » (en haut à droite), vous pouvez changer le nom du
profil en INIST ou INIST-PROXY ou tout autre nom à votre convenance :*

![webproxy_firefox_02](https://cloud.githubusercontent.com/assets/6779966/21499033/7e166b8c-cc32-11e6-8ebb-12aff451e41b.png)


#### Chrome/Chromium ####
[SwhitchySharp *(cliquer ici depuis Chrome/Chromium)*](https://chrome.google.com/webstore/detail/proxy-switchysharp/dpplabbmogkhghncfbfdeeokoefdjegm)

*Accédez à la configuration du plugin :*

![webproxy_chrome_01](https://cloud.githubusercontent.com/assets/6779966/21499712/8649dba8-cc38-11e6-8975-ac0b25e08f65.png)

*Modifiez la configuration ainsi :*

![webproxy_chrome_02](https://cloud.githubusercontent.com/assets/6779966/21565351/f7ee2f56-ce96-11e6-9d3f-b74f12e34805.png)


#### 📃 Note ####

Tous les navigateurs sont capables de prendre en charge la configuration de
l'environnement. Ainsi, si vous utilisez l'option « proxy système » des
extensions, les navigateurs utiliseront le proxy spécifié avec la commande ``inist shell``.

A noter que Chrome et Chromium se basent sur la configuration du desktop qui est donc réglable par ``inist desktop <on|off>``


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

    apt, bower, curl, docker,
    env (environnement système), github, gnome,
    kde, npm, ntp, shell (alias de env), unity,
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
### Variables d'environnement ###

#### $INIST_SERVICES ####
inist-tools utilise la variable d'environnement ``$INIST_SERVICES`` qui
permet, lorsque que vous faites ``inist on`` ou ``inist off``
de ne paramétrer pour le proxy INIST (ou ADSL) qu'une partie des services.

Les services que vous pouvez paramétrer sont : ``desktop apt docker github npm
curl bower wget``.

Ainsi, si vous faites :

```bash
$ INIST_SERVICES="apt docker github bower" inist off
```
*(dans ce cas précis, la variable ```$INIST_SERVICES``` n'est prise en compte
qu'une seule fois, au moment de l'execution de ``inist off``)*

ou bien :

```bash
$ export INIST_SERVICES="apt docker github bower"
$ inist off
```
*(dans ce cas précis, la variable ```$INIST_SERVICES``` est prise en compte
pour toute la durée du shell courant)*

vous obtiendrez :

```bash
Désactivation du proxy INIST pour toutes les applications...
[INFO]		« shell » n'est plus configuré pour fonctionner à l'INIST
[INFO]		« apt » n'est plus configuré pour fonctionner à l'INIST
[INFO]		« docker » n'est plus configuré pour fonctionner à l'INIST
[INFO]		« github » n'est plus configuré pour fonctionner à l'INIST
[INFO]		« bower » n'est plus configuré pour fonctionner à l'INIST
```

Les autres services (desktop, npm, curl, wget) ne seront pas impactés.

#### $IT_GOURCE_* ####
Les variables d'environnement ``$IT_GOURCE_*`` sont utilisées exclusivement
dans le cadre de la commande ``inist gource`` (voir ci-dessous).

### GOURCE ###
Inist-Tools permet de créer une animation Gource à partir d'un dépôt git.
Pour pouvoir fonctionner, vous devez avoir installé ces deux dépendances :

```bash
$ sudo apt-get install -y libav-tools gource
```

#### Générer un gource pour un dépôt ####
Vous devez renseigner les variables d'environnement suivantes 

  * ``IT_GOURCE_GITURL``
  
    L'url du dépôt git pour lequel vous souhaitez générer une animation gource<br />
    ex : ``$ export IT_GOURCE_GITURL="https://github.com/Inist-CNRS/inist-tools.git"``
    
  * ``$IT_GOURCE_SPRINTNAME``
  
    Le nom (du sprint) de votre animation <br />
    ex : ``$ export IT_GOURCE_SPRINTNAME="Démo gource pour inist-tools"``
    
  * ``$IT_GOURCE_SPRINTSTART``

    La date de début de la période pour laquelle l'animation sera produites
    sous la forme YYYY-MM-DD<br />
    ex : ``$ export IT_GOURCE_SPRINTSTART="2017-01-15"``
  
  * ``$IT_GOURCE_SPRINTEND``

    La date de fin de la période pour laquelle l'animation sera produites
    sous la forme YYYY-MM-DD<br />
    ex : ``$ export IT_GOURCE_SPRINTEND="2017-02-28"``

  * ``$IT_GOURCE_AVATARSDIR``

    Le chemin vers le répertoire contenant les avatars des contributeurs au
    dépôt pour lequel vous produisez l'animation. Par défaut, si vous ne 
    renseignez pas cette variable, le répertoire utilisé est 
    ``/opt/inist-tools/libs/gfx/avatars/``<br />
    ex : ``$ export IT_GOURCE_AVATARSDIR="/tmp/avatars"``
  

Puis lancer la génération du "gource" dans inist-tools s'utilise ainsi :

```bash
$ inist gource
```

Le fichier webm (vidéo pour le web) sera généré dans un répertoire de /tmp
qui vous sera donné à la fin de l'opération.


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


## CONFIGURATION ##
### Docker Opts ###
Si vous utilisez des options particulières au lancement de docker, vous pouvez
les préciser dans le fichier ```/opt/inist-tools/conf/docker-opts.conf```
**sur une
seule ligne** telles que vous les auriez ajoutées vous-même dans le fichier
/etc/default/docker.

Exemple :

```
-g /data/docker
```
