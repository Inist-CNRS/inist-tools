# inist-tools #
Ensemble d'outils permettant de faire fonctionner un poste GNU/Linux (Debian,
Ubuntu) dans l'environnement INIST.

## INSTALLATION ##

Pour l'heure, l'installation n'est pas automatisée.

Pour faire fonctionner la commande « inist » dans l'environnement courant, il
faut configurer les éléments suivants :


### /opt ###

En tant que root, créer un lien symbolique vers le répertoire où a été pullé
inist-tools :

```bash
/opt # ln -s /chemin/vers/le/pull/de/inist-tools .
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


----

## Commandes ##

Une fois "sourcé", les commandes suivent le schéma suivant :

```bash
$ inist commande [-option|--option-longue]
$ inist [-option|--option-longue]
```

##### proxy #####
```bash
$ inist proxy [on|off] [--firefox|--iceweasel|--chrome|--chromium]
```
Active/désactive les variables d'environnement qui prennent en charge le proxy
INIST<br>
Avec [--firefox|--iceweasel|--chrome|--chromium], prend en charge la
configuration spécifique des navigateurs.

#### Options ####

```bash
$ inist -h | --help
```
Fournit l'aide des commandes « inist-tools ».

```bash
$ inist -v | --version
```

Renseigne sur la version actuelle de « inist-tools »

---

## DEV ##

*__Note__ : <br> La commande « inist » devient disponible dans la console parce 
que le fichier "inistrc" est sourcé au lancement de celle-ci. Toute modification
du fichier inistrc ou des sous-commande nécessite à nouveau que le fichier
inistrc soit sourcé pour être prise en compte.<br>
Pour facilier cette opération, la commande 'inist reload' permet de recharger
le fichier inistrc directement dans l'environnement courant.
*

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

