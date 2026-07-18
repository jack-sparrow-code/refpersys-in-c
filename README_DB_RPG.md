# **📚 RefPerSys-in-C : Guide Complet Base de Données RPG**
> *Utilisation des plugins Python (db-explore) et Lua (rpg-irc-bot) avec MySQL/MariaDB*
> *Environnement : `jean-christophe@blues-softwares`*

**Version :** 1.0.0 | **Dernière mise à jour :** 18 juillet 2026

---

## **📖 TABLE DES MATIÈRES**

1. [🎯 INTRODUCTION](#-introduction)
2. [📋 PRÉREQUIS](#-prérequis)
3. [🛠 INSTALLATION COMPLÈTE](#-installation-complète)
4. [🗃 ARCHITECTURE DE LA BASE DE DONNÉES RPG](#-architecture-de-la-base-de-données-rpg)
5. [🐍 PLUGIN DB-EXPLORE (PYTHON + MYSQL)](#-plugin-db-explore-python--mysql)
6. [🌙 PLUGIN RPG-IRC-BOT (LUA)](#-plugin-rpg-irc-bot-lua)
7. [🔗 INTÉGRATION ENTRE LES PLUGINS](#-intégration-entre-les-plugins)
8. [🚀 WORKFLOWS COMPLETS](#-workflows-complets)
9. [📋 RÉFÉRENCE COMPLÈTE DES COMMANDES](#-référence-complète-des-commandes)
10. [🔍 DÉPANNAGE](#-dépannage)
11. [🔒 SÉCURITÉ ET BONNES PRATIQUES](#-sécurité-et-bonnes-pratiques)
12. [📝 EXEMPLES CONCRETS](#-exemples-concrets)
13. [❓ FAQ](#-faq)
14. [📊 ANNEXES](#-annexes)

---

## **🎯 INTRODUCTION**

Ce guide **exhaustif et détaillé** explique comment installer, configurer et utiliser **RefPerSys-in-C** avec ses **plugins Python (db-explore)** et **Lua (rpg-irc-bot)** pour créer, gérer et tester une **base de données RPG fictive** sur le serveur `blues-softwares`.

### **🎮 À QUOI ÇA SERT ?**

- ✅ Créer une **base de données MySQL/MariaDB** pour un jeu de rôle (RPG)
- ✅ Générer des **données fictives** (personnages, monstres, objets, quêtes)
- ✅ Utiliser **RefPerSys-in-C** comme moteur principal
- ✅ Intégrer **Python** pour la persistance des données via le plugin `db-explore`
- ✅ Utiliser **Lua** pour la génération de données et la logique RPG via le plugin `rpg-irc-bot`
- ✅ **Tout automatiser** avec des scripts shell

### **🏗 ARCHITECTURE DU PROJET**

```
refpersys-in-c/
├── src/                      # Code source C de RefPerSys
├── include/                  # En-têtes C
├── tools/                    # Scripts utilitaires
│   ├── db-explore.sh         # Wrapper pour le plugin Python
│   ├── rpg-prompt.sh         # Wrapper pour le plugin Lua
│   ├── rpg-db-manager.sh     # Gestion intégrée RPG + Base
│   └── demo_rpg_database.sh   # Démonstration complète
│
├── plugins/                  # Plugins externes
│   ├── db-explore/           # Plugin Python pour MySQL
│   │   ├── config.py         # Configuration MySQL
│   │   ├── create_database.py # Création base de données
│   │   ├── create_rpg_tables.py # Création tables RPG
│   │   ├── import_rpg_data.py # Import des données RPG
│   │   ├── test_rpg_database.py # Tests automatiques
│   │   └── ...
│   │
│   └── rpg-irc-bot/          # Plugin Lua pour RPG
│       ├── command_prompt.lua # Moteur RPG principal
│       ├── generate_sql_data.lua # Génération données SQL
│       └── ...
│
├── Makefile                  # Makefile principal
└── refpersys                 # Exécutable compilé
```

### **🔄 FLUX DE TRAVAIL**

```
Lua (rpg-irc-bot) → Génère des données RPG
       ↓
Python (db-explore) → Persiste dans MySQL
       ↓
RefPerSys-in-C → Orchestre l'ensemble
       ↓
MySQL/MariaDB → Stocke les données
```

---

## **📋 PRÉREQUIS**

### **📊 MATRICE DES DÉPENDANCES**

| Composant | Version Requise | Vérification | Package Debian |
|-----------|------------------|--------------|----------------|
| **Système** | Debian Trixie+ | `cat /etc/os-release` | - |
| **Python** | 3.11+ | `python3 --version` | `python3` |
| **MySQL/MariaDB** | 10.5+/8.0+ | `mysql --version` | `mariadb-server` |
| **Lua** | 5.4+ | `lua5.4 --version` | `lua5.4` |
| **LuaFileSystem** | 1.8.0+ | `lua5.4 -e "require('lfs')"` | `lua-filesystem` |
| **mysql-connector** | 9.7.0+ | `python3 -c "import mysql.connector"` | `python3-mysql.connector` |
| **Git** | 2.0+ | `git --version` | `git` |
| **GCC** | 12+ | `gcc --version` | `build-essential` |
| **GTK+ 3.0** | 3.24+ | `pkg-config --modversion gtk+-3.0` | `libgtk-3-dev` |
| **libcurl** | 7.0+ | `curl --version` | `libcurl4-openssl-dev` |
| **Jansson** | 2.13+ | `pkg-config --modversion jansson` | `libjansson-dev` |
| **libbacktrace** | 1.0+ | - | `libbacktrace-dev` |

### **💾 ESPACE DISQUE REQUIS : ~450 Mo**

---

## **🛠 INSTALLATION COMPLÈTE**

### **📥 ÉTAPE 1 : PRÉPARATION DU SERVEUR**

```bash
# Se connecter à blues-softwares
ssh jean-christophe@blues-softwares

# Mettre à jour le système
sudo apt update && sudo apt upgrade -y

# Redémarrer si nécessaire
sudo reboot
```

### **📦 ÉTAPE 2 : INSTALLATION DES DÉPENDANCES**

```bash
# Dépendances de compilation
sudo apt install -y build-essential git make cmake autoconf automake libtool

# Dépendances pour RefPerSys
sudo apt install -y libcurl4-openssl-dev libjansson-dev libgtk-3-dev libbacktrace-dev

# MySQL/MariaDB
sudo apt install -y mariadb-server mariadb-client

# Python et ses dépendances
sudo apt install -y python3 python3-pip python3-dev python3-mysql.connector

# Lua et ses dépendances
sudo apt install -y lua5.4 lua5.4-dev lua-filesystem

# Outils utiles
sudo apt install -y wget curl nano vim tree htop
```

### **✅ ÉTAPE 3 : VÉRIFICATION DES INSTALLATIONS**

```bash
echo "=== Vérification ==="
python3 --version
python3 -c "import mysql.connector; print('✅ Python MySQL: OK')"
lua5.4 --version
lua5.4 -e "require('lfs'); print('✅ LuaFileSystem: OK')"
mysql --version
sudo systemctl status mariadb
pkg-config --modversion gtk+-3.0
gcc --version | head -1
```

### **📦 ÉTAPE 4 : INSTALLATION DE REFPERSYS-IN-C**

```bash
cd /home/jean-christophe/Documents/codes/refpersys-in-c

# Exécuter le script d'installation
./install.sh

# Compiler le projet
make -j$(nproc)

# Vérifier
ls -lh refpersys  # Doit exister, ~20-50 Mo
```

### **📥 ÉTAPE 5 : INSTALLATION DES PLUGINS**

```bash
# Créer le dossier plugins
mkdir -p plugins

# Cloner les plugins
git clone https://github.com/jack-sparrow-code/db-explore.git plugins/db-explore
git clone https://github.com/jack-sparrow-code/rpg-irc-bot.git plugins/rpg-irc-bot

# Vérifier
ls -la plugins/
```

### **⚙ ÉTAPE 6 : CONFIGURATION DE MYSQL/MARIADB**

```bash
# Démarrer et activer MySQL
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Sécuriser MySQL (recommandé)
sudo mysql_secure_installation

# Se connecter en root
sudo mysql -u root
```

**Dans MySQL, exécuter :**

```sql
-- 1. Créer l'utilisateur MySQL
CREATE USER IF NOT EXISTS 'jean-christophe'@'localhost' 
    IDENTIFIED BY 'Coding2029';
CREATE USER IF NOT EXISTS 'jean-christophe'@'%' 
    IDENTIFIED BY 'Coding2029';

-- 2. Créer la base de données RPG
CREATE DATABASE IF NOT EXISTS rpg_database 
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 3. Donner les permissions
GRANT ALL PRIVILEGES ON rpg_database.* 
    TO 'jean-christophe'@'localhost';
GRANT ALL PRIVILEGES ON rpg_database.* 
    TO 'jean-christophe'@'%';

-- 4. Appliquer les changements
FLUSH PRIVILEGES;

-- 5. Vérifier
SHOW DATABASES;
EXIT;
```

**Configurer l'accès distant (optionnel) :**

```bash
sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf
# Changer : bind-address = 127.0.0.1
# En :     bind-address = 0.0.0.0
sudo systemctl restart mariadb
sudo ufw allow 3306
```

### **🔧 ÉTAPE 7 : CONFIGURATION DES PLUGINS**

**Configurer db-explore :**

```bash
nano plugins/db-explore/config.py
```

```python
# config.py
DB_CONFIG = {
    "host": "localhost",
    "user": "jean-christophe",
    "password": "Coding2029",
    "database": "rpg_database"
}
```

**Protéger le fichier de configuration :**

```bash
# Créer un fichier d'exemple
cp plugins/db-explore/config.py plugins/db-explore/config.py.example

# Éditer config.py.example pour enlever les vrais identifiants
nano plugins/db-explore/config.py.example

# Ajouter au .gitignore
echo "plugins/db-explore/config.py" >> .gitignore
git rm --cached plugins/db-explore/config.py 2>/dev/null || true
```

### **✅ ÉTAPE 8 : TEST DE LA CONFIGURATION**

```bash
# Tester la connexion MySQL
mysql -u jean-christophe -pCoding2029 -e "SHOW DATABASES;"

# Tester le plugin Python
python3 -c "
import mysql.connector
from plugins.db-explore.config import DB_CONFIG
conn = mysql.connector.connect(**DB_CONFIG)
print('✅ Connexion Python MySQL: OK')
conn.close()
"

# Tester le plugin Lua
lua5.4 -e "print('✅ Lua: OK')"
lua5.4 -e "require('lfs'); print('✅ LuaFileSystem: OK')"
```

---

## **🗃 ARCHITECTURE DE LA BASE DE DONNÉES RPG**

### **📊 MODÈLE CONCEPTUEL**

```
+-------------------+
|   RPG_DATABASE    |
+-------------------+
|                   |
|  +-------------+  |
|  | PERSONNAGES |  |
|  +-------------+  |
|  | id (PK, AI) |  |
|  | nom         |  |
|  | classe      |  |
|  | niveau      |  |
|  | pv          |  |
|  | force       |  |
|  | agilite     |  |
|  | intelligence|  |
|  | or          |  |
|  | experience  |  |
|  +-------------+  |
|                   |
|  +-------------+  |
|  |  MONSTRES   |  |
|  +-------------+  |
|  | id (PK, AI) |  |
|  | nom         |  |
|  | type        |  |
|  | niveau      |  |
|  | pv          |  |
|  | attaque     |  |
|  | defense     |  |
|  | exp_donnee  |  |
|  +-------------+  |
|                   |
|  +-------------+  |
|  |   OBJETS    |  |
|  +-------------+  |
|  | id (PK, AI) |  |
|  | nom         |  |
|  | type        |  |
|  | valeur      |  |
|  | rareté      |  |
|  +-------------+  |
|                   |
|  +-------------+  |
|  |   QUÊTES    |  |
|  +-------------+  |
|  | id (PK, AI) |  |
|  | titre       |  |
|  | description |  |
|  | exp_recomp  |  |
|  | or_recomp   |  |
|  | statut      |  |
|  +-------------+  |
+-------------------+
```

### **📋 TABLES EN DÉTAIL**

#### **👥 Table : personnages**

| Colonne | Type | Description | Défaut |
|---------|------|-------------|--------|
| `id` | INT | Identifiant unique (PK, AI) | - |
| `nom` | VARCHAR(50) | Nom du personnage | - |
| `classe` | VARCHAR(30) | Classe du personnage | - |
| `niveau` | INT | Niveau du personnage | 1 |
| `points_de_vie` | INT | Points de vie | 100 |
| `force` | INT | Attribute force | 10 |
| `agilite` | INT | Attribute agilité | 10 |
| `intelligence` | INT | Attribute intelligence | 10 |
| `or` | INT | Quantité d'or | 0 |
| `experience` | INT | Points d'expérience | 0 |

**Index :** `PRIMARY KEY (id), INDEX idx_classe (classe), INDEX idx_niveau (niveau)`

#### **👹 Table : monstres**

| Colonne | Type | Description | Défaut |
|---------|------|-------------|--------|
| `id` | INT | Identifiant unique (PK, AI) | - |
| `nom` | VARCHAR(50) | Nom du monstre | - |
| `type` | VARCHAR(30) | Type de monstre | - |
| `niveau` | INT | Niveau du monstre | 1 |
| `points_de_vie` | INT | Points de vie | 50 |
| `attaque` | INT | Points d'attaque | 5 |
| `defense` | INT | Points de défense | 5 |
| `experience_donnee` | INT | Expérience donnée | 10 |

**Index :** `PRIMARY KEY (id), INDEX idx_type (type), INDEX idx_niveau (niveau)`

#### **🎒 Table : objets**

| Colonne | Type | Description | Défaut |
|---------|------|-------------|--------|
| `id` | INT | Identifiant unique (PK, AI) | - |
| `nom` | VARCHAR(50) | Nom de l'objet | - |
| `type` | VARCHAR(30) | Type d'objet | - |
| `valeur` | INT | Valeur en or | 0 |
| `rareté` | VARCHAR(20) | Rareté de l'objet | 'commun' |

**Index :** `PRIMARY KEY (id), INDEX idx_type (type), INDEX idx_rareté (rareté)`

#### **📜 Table : quetes**

| Colonne | Type | Description | Défaut |
|---------|------|-------------|--------|
| `id` | INT | Identifiant unique (PK, AI) | - |
| `titre` | VARCHAR(100) | Titre de la quête | - |
| `description` | TEXT | Description de la quête | - |
| `experience_recompense` | INT | Expérience donnée | 50 |
| `or_recompense` | INT | Or donné | 100 |
| `statut` | VARCHAR(20) | Statut de la quête | 'en_cours' |

**Index :** `PRIMARY KEY (id), INDEX idx_statut (statut)`

---

## **🐍 PLUGIN DB-EXPLORE (PYTHON + MYSQL)**

### **📁 STRUCTURE**

```
plugins/db-explore/
├── config.py              # Configuration MySQL
├── create_database.py     # Crée la base et table utilisateurs
├── create_rpg_tables.py   # Crée les tables RPG
├── insert_data.py         # Insère un utilisateur
├── update_data.py         # Met à jour un utilisateur
├── query_data.py          # Liste les utilisateurs
├── main.py                # Menu interactif
├── import_rpg_data.py     # Importe les données RPG
└── test_rpg_database.py   # Tests automatiques
```

### **🚀 COMMANDES PRINCIPALES**

#### **Via le wrapper shell (`tools/db-explore.sh`)**

```bash
# Création et gestion de base
./tools/db-explore.sh create          # Crée la base et table utilisateurs
./tools/db-explore.sh setup          # Initialisation complète

# CRUD sur les utilisateurs (table générique)
./tools/db-explore.sh insert "Nom" 25   # Insère un utilisateur
./tools/db-explore.sh update "Nom" 26   # Met à jour
./tools/db-explore.sh query           # Liste tous
./tools/db-explore.sh delete "Nom"     # Supprime

# Commandes via SSH
./tools/db-explore.sh ssh-create       # Crée via SSH
./tools/db-explore.sh ssh-insert "N" 25 # Insère via SSH
./tools/db-explore.sh ssh-query        # Liste via SSH

# Sauvegarde et restauration
./tools/db-explore.sh backup           # Sauvegarde la base
./tools/db-explore.sh restore backup.sql # Restaure

# Menu
./tools/db-explore.sh menu            # Menu interactif
./tools/db-explore.sh help            # Affiche l'aide
```

#### **Python direct**

```bash
python3 plugins/db-explore/create_database.py     # Crée la base
python3 plugins/db-explore/create_rpg_tables.py    # Crée les tables RPG
python3 plugins/db-explore/import_rpg_data.py      # Importe les données
python3 plugins/db-explore/test_rpg_database.py    # Exécute les tests
```

---

## **🌙 PLUGIN RPG-IRC-BOT (LUA)**

### **📁 STRUCTURE**

```
plugins/rpg-irc-bot/
├── command_prompt.lua       # Moteur RPG principal
├── generate_sql_data.lua    # Génère des données SQL
└── modules/                # Modules Lua
    └── character.lua        # Gestion des personnages
```

### **🚀 COMMANDES PRINCIPALES**

#### **Via le wrapper shell (`tools/rpg-prompt.sh`)**

```bash
# Menu et aide
./tools/rpg-prompt.sh                    # Menu interactif
./tools/rpg-prompt.sh "!help"            # Affiche l'aide

# Gestion des personnages
./tools/rpg-prompt.sh "!createplayer"    # Crée un personnage
./tools/rpg-prompt.sh "!listplayer"     # Liste les personnages
./tools/rpg-prompt.sh "!setclass Mage"  # Définit la classe
./tools/rpg-prompt.sh "!setrace Elfe"   # Définit la race
./tools/rpg-prompt.sh "!stats"          # Affiche les stats
./tools/rpg-prompt.sh "!levelup"        # Monte de niveau

# Dés
./tools/rpg-prompt.sh "!roll 3"         # Lance 3 dés
./tools/rpg-prompt.sh "!roll 2d20"       # Lance 2 dés à 20 faces

# Monstres
./tools/rpg-prompt.sh "!createmonster Troll Geant 10" # Crée un monstre
./tools/rpg-prompt.sh "!listmonster"             # Liste les monstres

# Objets
./tools/rpg-prompt.sh "!createitem Epee Arme 50"   # Crée un objet
./tools/rpg-prompt.sh "!listitem"                # Liste les objets

# Quêtes
./tools/rpg-prompt.sh "!createquest Titre Desc" # Crée une quête
./tools/rpg-prompt.sh "!listquest"              # Liste les quêtes
```

#### **Lua direct**

```bash
lua5.4 plugins/rpg-irc-bot/command_prompt.lua           # Menu interactif
lua5.4 plugins/rpg-irc-bot/generate_sql_data.lua        # Génère des données SQL
lua5.4 plugins/rpg-irc-bot/generate_sql_data.lua > data.sql  # Sauvegarde dans un fichier
```

---

## **🔗 INTÉGRATION ENTRE LES PLUGINS**

### **🎯 WORKFLOW D'INTÉGRATION**

```
1. Lua génère des données RPG (personnages, monstres, etc.)
       ↓
2. generate_sql_data.lua convertit en requêtes SQL
       ↓
3. Python importe les données dans MySQL via import_rpg_data.py
       ↓
4. RefPerSys utilise les wrappers pour orchestrer
```

### **📦 SCRIPTS D'INTÉGRATION**

#### **`tools/rpg-db-manager.sh` - Gestion Intégrée**

```bash
./tools/rpg-db-manager.sh setup              # Initialisation complète
./tools/rpg-db-manager.sh generate-lua-data   # Génère des données Lua
./tools/rpg-db-manager.sh import             # Importe les données
./tools/rpg-db-manager.sh list-personnages   # Liste les personnages
./tools/rpg-db-manager.sh list-monstres     # Liste les monstres
./tools/rpg-db-manager.sh list-alles        # Liste tout
./tools/rpg-db-manager.sh test-rpg           # Test complet
```

#### **`tools/demo_rpg_database.sh` - Démonstration Complète**

Exécute tout le workflow en une seule commande :

```bash
./tools/demo_rpg_database.sh
```

**Ce qu'il fait :**
1. ✅ Vérifie l'environnement
2. ✅ Configure la base de données
3. ✅ Génère des données avec Lua
4. ✅ Importe les données dans MySQL
5. ✅ Exécute les tests automatiques
6. ✅ Affiche les statistiques

---

## **🚀 WORKFLOWS COMPLETS**

### **📌 WORKFLOW 1 : INSTALLATION COMPLÈTE DEPUIS ZÉRO**

```bash
# 1. Se connecter
ssh jean-christophe@blues-softwares

# 2. Installer les dépendances
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential git make libcurl4-openssl-dev libjansson-dev libgtk-3-dev libbacktrace-dev
sudo apt install -y mariadb-server python3 python3-mysql.connector lua5.4 lua-filesystem

# 3. Compiler RefPerSys
cd /home/jean-christophe/Documents/codes/refpersys-in-c
./install.sh
make -j$(nproc)

# 4. Configurer MySQL
sudo mysql_secure_installation
sudo mysql -u root
# Exécuter les commandes SQL de création d'utilisateur et de base

# 5. Configurer et créer la base
nano plugins/db-explore/config.py  # Mettre à jour la config
./tools/rpg-db-manager.sh setup

# 6. Tester
./tools/demo_rpg_database.sh
```

### **📌 WORKFLOW 2 : CRÉATION RAPIDE D'UNE BASE DE TEST**

```bash
cd /home/jean-christophe/Documents/codes/refpersys-in-c

# 1. Créer les tables RPG
python3 plugins/db-explore/create_rpg_tables.py

# 2. Générer des données avec Lua
lua5.4 plugins/rpg-irc-bot/generate_sql_data.lua > /tmp/test_data.sql

# 3. Importer les données
python3 plugins/db-explore/import_rpg_data.py /tmp/test_data.sql

# 4. Vérifier
mysql -u jean-christophe -pCoding2029 rpg_database -e "SELECT COUNT(*) FROM personnages;"
```

### **📌 WORKFLOW 3 : GÉNÉRATION DE DONNÉES ALÉATOIRES**

```bash
# Créer un script de génération massive
nano plugins/db-explore/generate_mass_data.py
# (Voir l'exemple dans les Exemples Concrets)

python3 plugins/db-explore/generate_mass_data.py
```

### **📌 WORKFLOW 4 : SAUVEGARDE ET RESTAURATION**

```bash
# Sauvegarder
mysqldump -u jean-christophe -pCoding2029 rpg_database > ~/backups/rpg_$(date +%Y%m%d).sql

# Restaurer
mysql -u jean-christophe -pCoding2029 -e "DROP DATABASE rpg_database; CREATE DATABASE rpg_database;"
mysql -u jean-christophe -pCoding2029 rpg_database < ~/backups/rpg_20260718.sql

# Ou via le wrapper
./tools/db-explore.sh backup
./tools/db-explore.sh restore ~/backups/rpg_20260718.sql
```

### **📌 WORKFLOW 5 : TESTS AUTOMATIQUES**

```bash
# Exécuter tous les tests
python3 plugins/db-explore/test_rpg_database.py

# Exécuter un test spécifique
python3 -c "from test_rpg_database import test_connexion; test_connexion()"
```

### **📌 WORKFLOW 6 : UTILISATION QUOTIDIENNE**

```bash
ssh jean-christophe@blues-softwares
cd /home/jean-christophe/Documents/codes/refpersys-in-c

# Créer un personnage
./tools/rpg-prompt.sh "!createplayer"

# Lister les personnages
./tools/rpg-db-manager.sh list-personnages

# Ajouter un monstre
./tools/rpg-prompt.sh "!createmonster Licorne Magique 5"

# Faire un combat de test
python3 plugins/db-explore/test_rpg_database.py
```

---

## **📋 RÉFÉRENCE COMPLÈTE DES COMMANDES**

---

### **📌 TABLEAU RÉCAPITULATIF**

#### **Commandes Générales**

| Catégorie | Commande | Description |
|----------|----------|-------------|
| Système | `ssh jean-christophe@blues-softwares` | Connexion SSH |
| Système | `sudo systemctl start mariadb` | Démarrer MySQL |
| Système | `sudo systemctl stop mariadb` | Arrêter MySQL |
| Système | `sudo systemctl restart mariadb` | Redémarrer MySQL |
| Système | `make -j$(nproc)` | Compiler RefPerSys |
| Système | `./refpersys` | Lancer RefPerSys |

#### **Commandes db-explore.sh**

| Commande | Arguments | Description |
|----------|-----------|-------------|
| `create` | - | Crée la base et table utilisateurs |
| `insert` | `<nom> <age>` | Insère un utilisateur |
| `update` | `<nom> <age>` | Met à jour un utilisateur |
| `query` | - | Liste les utilisateurs |
| `delete` | `<nom>` | Supprime un utilisateur |
| `menu` | - | Menu interactif |
| `help` | - | Affiche l'aide |
| `ssh-create` | - | Crée via SSH |
| `ssh-insert` | `<nom> <age>` | Insère via SSH |
| `ssh-query` | - | Liste via SSH |
| `setup` | - | Initialisation complète |
| `backup` | - | Sauvegarde la base |
| `restore` | `<fichier.sql>` | Restaure la base |

#### **Commandes rpg-prompt.sh**

| Commande | Arguments | Description |
|----------|-----------|-------------|
| (aucun) | - | Menu interactif |
| `!help` | - | Affiche l'aide |
| `!createplayer` | - | Crée un personnage |
| `!listplayer` | - | Liste les personnages |
| `!setclass` | `<classe>` | Définit la classe |
| `!setrace` | `<race>` | Définit la race |
| `!stats` | - | Affiche les stats |
| `!levelup` | - | Monte de niveau |
| `!roll` | `<N>` ou `<N>d<F>` | Lance des dés |
| `!createmonster` | `<nom> <type> <niveau>` | Crée un monstre |
| `!listmonster` | - | Liste les monstres |
| `!createitem` | `<nom> <type> <valeur>` | Crée un objet |
| `!listitem` | - | Liste les objets |
| `!createquest` | `<titre> <description>` | Crée une quête |
| `!listquest` | - | Liste les quêtes |

#### **Commandes rpg-db-manager.sh**

| Commande | Description |
|----------|-------------|
| `setup` | Initialisation complète |
| `generate-lua-data` | Génère des données Lua |
| `import` | Importe les données |
| `list-personnages` | Liste les personnages |
| `list-monstres` | Liste les monstres |
| `list-alles` | Liste tout |
| `test-rpg` | Test complet |

#### **Commandes Python Directes**

```bash
python3 plugins/db-explore/create_database.py      # Crée la base
python3 plugins/db-explore/create_rpg_tables.py     # Crée les tables RPG
python3 plugins/db-explore/import_rpg_data.py       # Importe les données
python3 plugins/db-explore/test_rpg_database.py     # Tests
```

#### **Commandes Lua Directes**

```bash
lua5.4 plugins/rpg-irc-bot/command_prompt.lua        # Menu RPG
lua5.4 plugins/rpg-irc-bot/generate_sql_data.lua     # Génère des données SQL
```

#### **Commandes MySQL Directes**

```bash
mysql -u jean-christophe -p                      # Connexion interactive
mysql -u jean-christophe -p -e "SELECT * FROM personnages;"  # Exécute une requête
mysqldump -u jean-christophe -p rpg_database > backup.sql  # Sauvegarde
mysql -u jean-christophe -p rpg_database < backup.sql     # Restauration
```

---

## **🔍 DÉPANNAGE**

### **❌ PROBLÈMES COURANTS ET SOLUTIONS**

#### **🔴 MySQL ne démarre pas**

```bash
sudo journalctl -u mariadb -n 50
sudo systemctl restart mariadb
sudo mysql_secure_installation
```

#### **🔴 Connexion MySQL refusée**

```bash
sudo mysql -u root -e "SELECT User, Host FROM mysql.user;"
sudo mysql -u root -e "GRANT ALL ON rpg_database.* TO 'jean-christophe'@'localhost' IDENTIFIED BY 'Coding2029'; FLUSH PRIVILEGES;"
```

#### **🔴 mysql-connector non trouvé**

```bash
sudo apt install -y python3-mysql.connector
python3 -c "import mysql.connector; print('OK')"
```

#### **🔴 Lua non installé**

```bash
sudo apt install -y lua5.4 lua-filesystem
lua5.4 -e "require('lfs'); print('OK')"
```

#### **🔴 Base de données existe déjà**

```bash
mysql -u jean-christophe -pCoding2029 -e "DROP DATABASE IF EXISTS rpg_database;"
python3 plugins/db-explore/create_database.py
```

#### **🔴 Problème de permissions**

```bash
chmod +x tools/*.sh
chmod 755 tools/*.sh
chmod 644 plugins/db-explore/*.py
```

#### **🔴 RefPerSys ne compile pas**

```bash
sudo apt install -y libcurl4-openssl-dev libjansson-dev libgtk-3-dev libbacktrace-dev
make clean
make -j$(nproc)
```

---

## **🔒 SÉCURITÉ ET BONNES PRATIQUES**

### **🔐 PROTÉGER LES IDENTIFIANTS**

```bash
# Ne JAMAIS commiter config.py
echo "plugins/db-explore/config.py" >> .gitignore
git rm --cached plugins/db-explore/config.py

# Créer un fichier d'exemple
cp plugins/db-explore/config.py plugins/db-explore/config.py.example
# Éditer config.py.example pour enlever les vrais identifiants
```

### **👤 PERMISSIONS MySQL LIMITÉES**

```sql
-- Donner seulement les permissions nécessaires
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP 
    ON rpg_database.* 
    TO 'jean-christophe'@'localhost';
```

### **💾 SAUVEGARDES AUTOMATIQUES**

```bash
# Créer un script de sauvegarde
nano ~/backup_rpg_db.sh
```

```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/home/jean-christophe/backups/rpg_database"
mkdir -p "$BACKUP_DIR"
mysqldump -u jean-christophe -pCoding2029 rpg_database > "${BACKUP_DIR}/rpg_${DATE}.sql"
(cd "$BACKUP_DIR" && ls -t | tail -n +11 | xargs rm -f)
```

```bash
chmod +x ~/backup_rpg_db.sh
crontab -e
# Ajouter : 0 2 * * * /home/jean-christophe/backup_rpg_db.sh
```

### **🌐 LIMITER L'ACCÈS DISTANT**

```bash
# Dans /etc/mysql/mariadb.conf.d/50-server.cnf
bind-address = 127.0.0.1  # Pas de connexion distante

# Si nécessaire :
bind-address = 0.0.0.0
sudo ufw allow from 192.168.1.100 to any port 3306
```

---

## **📝 EXEMPLES CONCRETS**

### **📌 EXEMPLE 1 : CRÉATION D'UN PERSONNAGE COMPLET**

```bash
# 1. Créer avec Lua
./tools/rpg-prompt.sh "!createplayer"

# 2. Importer dans MySQL
mysql -u jean-christophe -pCoding2029 rpg_database -e "
INSERT INTO personnages 
(nom, classe, niveau, points_de_vie, force, agilite, intelligence, or, experience)
VALUES ('Gandalf', 'Mage', 10, 150, 15, 12, 20, 500, 1000);"

# 3. Vérifier
mysql -u jean-christophe -pCoding2029 rpg_database -e "
SELECT * FROM personnages WHERE nom = 'Gandalf';"
```

### **📌 EXEMPLE 2 : SIMULATION DE COMBAT**

```bash
python3 << EOF
import mysql.connector
from plugins.db-explore.config import DB_CONFIG
import random

conn = mysql.connector.connect(**DB_CONFIG)
cursor = conn.cursor(dictionary=True)

# Sélectionner des combattants aléatoires
cursor.execute("SELECT * FROM personnages ORDER BY RAND() LIMIT 1")
perso = cursor.fetchone()
cursor.execute("SELECT * FROM monstres ORDER BY RAND() LIMIT 1")
monstre = cursor.fetchone()

print(f"Combat: {perso['nom']} vs {monstre['nom']}")

# Calcul des dégâts
degats_perso = max(1, perso['force'] + perso['niveau'] - monstre['defense'])
degats_monstre = max(1, monstre['attaque'] - perso['agilite'])

if degats_perso >= degats_monstre:
    print(f"{perso['nom']} gagne !")
    cursor.execute("UPDATE personnages SET experience = experience + %s, or = or + 100 WHERE nom = %s",
                  (monstre['experience_donnee'], perso['nom']))
else:
    print(f"{monstre['nom']} gagne !")

conn.commit()
cursor.close()
conn.close()
EOF
```

### **📌 EXEMPLE 3 : GÉNÉRATION MASSIVE DE DONNÉES**

Créer `plugins/db-explore/generate_mass_data.py` :

```python
#!/usr/bin/env python3
import mysql.connector
from config import DB_CONFIG
import random

Noms = ["Aragorn", "Legolas", "Gimli", "Gandalf", "Frodon"]
Classes = ["Guerrier", "Mage", "Voleur", "Chasseur"]
MonstresNoms = ["Gobelin", "Orc", "Troll", "Dragon"]
MonstresTypes = ["Humanoïde", "Géant", "Dragon"]

conn = mysql.connector.connect(**DB_CONFIG)
cursor = conn.cursor()

# 100 personnages
for i in range(100):
    cursor.execute("""
        INSERT INTO personnages (nom, classe, niveau, points_de_vie, force, agilite, intelligence, or, experience)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
    """, (f"{random.choice(Noms)}_{i}", random.choice(Classes), random.randint(1,20),
           random.randint(50,200), random.randint(5,20), random.randint(5,20),
           random.randint(5,20), random.randint(0,1000), random.randint(0,5000)))

# 50 monstres
for i in range(50):
    cursor.execute("""
        INSERT INTO monstres (nom, type, niveau, points_de_vie, attaque, defense, experience_donnee)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
    """, (f"{random.choice(MonstresNoms)}_{i}", random.choice(MonstresTypes),
           random.randint(1,15), random.randint(20,150), random.randint(3,18),
           random.randint(2,15), random.randint(10,200)))

conn.commit()
print(f"✅ {cursor.rowcount} entrées générées")
cursor.close()
conn.close()
```

```bash
python3 plugins/db-explore/generate_mass_data.py
```

---

## **❓ FAQ (QUESTIONS FRÉQUENTES)**

### **🔹 QUESTIONS GÉNÉRALES**

**Q: Quelle est la différence entre MariaDB et MySQL ?**  
**R:** MariaDB est un fork open source de MySQL. Les deux sont compatibles. MariaDB est souvent préféré car 100% open source et mieux intégré avec Debian.

**Q: Puis-je utiliser PostgreSQL au lieu de MySQL ?**  
**R:** Oui, mais il faudrait adapter le plugin db-explore pour utiliser `psycopg2` au lieu de `mysql-connector`.

**Q: Pourquoi utiliser Python ET Lua ?**  
**R:** Python excelle pour la persistance (MySQL) et Lua pour la logique RPG. Cette combinaison permet d'avoir le meilleur des deux mondes.

**Q: RefPerSys est-il nécessaire pour utiliser les plugins ?**  
**R:** Non, les plugins peuvent être utilisés indépendamment. RefPerSys sert de moteur principal pour orchestrer.

### **🔹 PROBLÈMES TECHNIQUES**

**Q: "Too many connections" avec MySQL**  
**R:** `sudo mysql -u root -e "SET GLOBAL max_connections = 200;"`

**Q: Les accents ne s'affichent pas**  
**R:** Utiliser `CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci` pour la base et les tables.

**Q: Comment réinitialiser complètement la base ?**  
**R:** `mysql -u jean-christophe -p -e "DROP DATABASE rpg_database;"` puis recréer.

**Q: Comment exporter la structure sans les données ?**  
**R:** `mysqldump -u jean-christophe -p --no-data rpg_database > schema.sql`

### **🔹 INTÉGRATION**

**Q: Comment appeler les plugins depuis RefPerSys ?**  
**R:** Utiliser `system()` en C : `system("./tools/db-explore.sh create");`

**Q: Puis-je étendre RefPerSys avec de nouveaux types d'objets ?**  
**R:** Oui ! Ajoutez des tables MySQL, modifiez generate_sql_data.lua et créez de nouvelles commandes Lua.

---

## **📊 ANNEXES**

### **📄 ANNEXE A : SCHÉMA SQL COMPLET**

Voir le fichier : `plugins/db-explore/create_rpg_tables.py`

### **📄 ANNEXE B : .GITIGNORE RECOMMANDÉ**

```gitignore
# Configuration
plugins/db-explore/config.py

# Compilation
*.pyc
__pycache__/
*.pyo
*.o
refpersys

# Sauvegardes
*.sql
*.backup
*.bak

# Temporaire
/tmp/
*.tmp
*.swp
```

### **📄 ANNEXE C : VARIABLES D'ENVIRONNEMENT**

Ajoutez à `~/.bashrc` :

```bash
export DB_HOST="localhost"
export DB_USER="jean-christophe"
export DB_PASSWORD="Coding2029"
export DB_DATABASE="rpg_database"
export RPS_DIR="/home/jean-christophe/Documents/codes/refpersys-in-c"

alias rps-compile="cd $RPS_DIR && make -j\$(nproc)"
alias rps-run="cd $RPS_DIR && ./refpersys"
alias rps-db-setup="cd $RPS_DIR && ./tools/db-explore.sh setup"
```

---

## **🎯 CONCLUSION**

Ce guide **exhaustif et détaillé** vous a permis de comprendre comment :

✅ **Installer** RefPerSys, MySQL, Python et Lua  
✅ **Configurer** la base RPG avec tables et relations  
✅ **Utiliser** les plugins db-explore (Python) et rpg-irc-bot (Lua)  
✅ **Intégrer** les plugins avec RefPerSys  
✅ **Automatiser** avec des scripts shell  
✅ **Tester** le système complet  
✅ **Dépanner** les problèmes courants  
✅ **Optimiser** performances et sécurité  

### **🚀 PROCHAINES ÉTAPES**

1. Explorer les plugins : `plugins/db-explore/README_blues-softwares.md` et `plugins/rpg-irc-bot/DOCUMENTATION.md`
2. Personnaliser les tables et données
3. Étendre avec de nouvelles fonctionnalités
4. Intégrer à d'autres systèmes
5. Contribuer à la communauté

### **📚 RESSOURCES**

- [RefPerSys.org](http://refpersys.org/)
- [Documentation MySQL](https://dev.mysql.com/doc/)
- [Documentation MariaDB](https://mariadb.org/documentation/)
- [Documentation Python](https://docs.python.org/3/)
- [mysql-connector-python](https://dev.mysql.com/doc/connector-python/en/)

---

**📜 Licence :** GPLv3 | **Auteur :** Jean-Christophe Énée | **Contact :** jean-christophe@blues-softwares.net

---

*Fin du Guide Complet* 🎮🐍🌙🗃
