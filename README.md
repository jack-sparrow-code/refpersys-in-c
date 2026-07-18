# RefPerSys-in-C

> **Complete Rewrite of RefPerSys in C**
> *Reflective Persistent System - Version C*

**Site officiel :** [http://refpersys.org/](http://refpersys.org/)  
**Dépôt C++ précédent :** [RefPerSys/RefPerSys](https://github.com/RefPerSys/RefPerSys)  
**Licence :** GPL-3.0-or-later

---

## 📋 À Propos

**RefPerSys-in-C** est une réécriture complète en **langage C** du système **RefPerSys** (Reflective Persistent System). Il s'agit d'un système **réflexif et persistant** qui permet de :

- Créer et manipuler des objets dynamiquement
- Persister les données entre les sessions
- Étendre les fonctionnalités via des plugins
- Intégrer des langages de script (Python, Lua)
- Offrir une interface graphique (GTK+)

---

## 📦 Dépendances Requises

| Dépendance | Description | Package Debian | Vérification |
|------------|-------------|----------------|--------------|
| **libcurl** | Bibliothèque pour les transferts URL | `libcurl4-openssl-dev` | `curl --version` |
| **Jansson** | Bibliothèque JSON pour C | `libjansson-dev` | `pkg-config --modversion jansson` |
| **GTK+ 3.0** | Bibliothèque graphique | `libgtk-3-dev` | `pkg-config --modversion gtk+-3.0` |
| **libbacktrace** | Support des backtraces | `libbacktrace-dev` | - |
| **build-essential** | Outils de compilation | `build-essential` | `gcc --version` |
| **git** | Contrôle de version | `git` | `git --version` |
| **make** | Outil de build | `make` | `make --version` |

---

## 🚀 Installation

### 1. Installer les dépendances

```bash
# Sur Debian/Ubuntu
sudo apt update
sudo apt install -y build-essential git make cmake autoconf automake libtool
sudo apt install -y libcurl4-openssl-dev libjansson-dev libgtk-3-dev libbacktrace-dev
```

### 2. Cloner le dépôt

```bash
cd /chemin/vers/vos/projets
git clone https://github.com/RefPerSys/refpersys-in-c.git
cd refpersys-in-c
```

### 3. Exécuter le script d'installation

```bash
./install.sh
```

Ce script va :
- Vérifier que toutes les dépendances sont installées
- Configurer l'environnement de build
- Préparer la compilation

### 4. Compiler le projet

```bash
make -j$(nproc)
```

> **Note :** Utilisez `-j$(nproc)` pour compiler en parallèle sur tous les cœurs disponibles.

### 5. Vérifier l'installation

```bash
ls -lh refpersys  # Doit afficher l'exécutable (~20-50 Mo)
./refpersys --version  # Vérifier que l'exécutable fonctionne
```

---

## 🎯 Fonctionnalités Principales

### ✅ Noyau RefPerSys

- **Gestion d'objets dynamiques** : Création, modification, suppression d'objets à la volée
- **Persistance** : Sauvegarde et restauration automatique des données
- **Réflexivité** : Introspection des types et des objets
- **Gestion mémoire avancée** : Allocation optimisée avec garbage collection
- **Multithreading** : Support des threads pour les opérations simultanées

### ✅ Interface Utilisateur

- **Mode texte** : Interface en ligne de commande
- **Mode graphique (GTK)** : Interface graphique avec `./refpersys --gui`
- **Mode batch** : Exécution sans interface avec `./refpersys --batch`

### ✅ Extensibilité

- **Plugins Python** : Intégration avec Python via des scripts externes
- **Plugins Lua** : Support natif de Lua pour la logique métier
- **Appels système** : Possibilité d'appeler n'importe quel programme externe
- **API C** : Bibliothèque utilisable depuis d'autres programmes C

---

## 🪐 Plugins Disponibles

RefPerSys-in-C peut être étendu avec des plugins externes pour ajouter des fonctionnalités spécifiques.

---

### 🐍 Plugin **db-explore** (Python + MySQL/MariaDB)

> **Gestion de bases de données SQL pour RefPerSys**

**Fonctionnalités :**
- Création et gestion de bases de données MySQL/MariaDB
- Tables RPG (personnages, monstres, objets, quêtes)
- Import/Export de données
- Tests automatiques
- Intégration complète avec RefPerSys

**Structure :**
```
plugins/db-explore/
├── config.py              # Configuration MySQL
├── create_database.py     # Crée la base et les tables
├── create_rpg_tables.py   # Crée les tables RPG
├── import_rpg_data.py     # Importe les données RPG
├── test_rpg_database.py   # Tests automatiques
├── main.py                # Menu interactif
└── ...
```

**Commandes principales :**
```bash
# Création et gestion
./tools/db-explore.sh create       # Crée la base de données
./tools/db-explore.sh setup       # Initialisation complète
./tools/db-explore.sh query        # Liste les utilisateurs

# Gestion des données RPG
python3 plugins/db-explore/create_rpg_tables.py   # Crée les tables RPG
python3 plugins/db-explore/import_rpg_data.py     # Importe les données
python3 plugins/db-explore/test_rpg_database.py   # Exécute les tests
```

**Documentation :**
- [Guide d'installation](plugins/db-explore/INSTALL_blues-softwares.md)
- [Liste des commandes](plugins/db-explore/COMMANDS_blues-softwares.md)
- [Documentation complète](plugins/db-explore/README_blues-softwares.md)

---

### 🌙 Plugin **rpg-irc-bot** (Lua)

> **Système RPG complet en Lua pour RefPerSys**

**Fonctionnalités :**
- Création et gestion de personnages RPG
- Système de monstres et combats
- Gestion d'objets et quêtes
- Lancement de dés
- Génération de données SQL
- Intégration avec MySQL

**Structure :**
```
plugins/rpg-irc-bot/
├── command_prompt.lua       # Moteur RPG principal
├── generate_sql_data.lua    # Génère des données SQL pour la base
├── modules/
│   └── character.lua        # Gestion des personnages
└── DOCUMENTATION.md         # Documentation complète
```

**Commandes principales :**
```bash
# Menu interactif
./tools/rpg-prompt.sh                     # Lance le RPG
./tools/rpg-prompt.sh "!help"             # Affiche l'aide

# Gestion des personnages
./tools/rpg-prompt.sh "!createplayer"     # Crée un personnage
./tools/rpg-prompt.sh "!listplayer"      # Liste les personnages
./tools/rpg-prompt.sh "!setclass Mage"   # Définit la classe
./tools/rpg-prompt.sh "!stats"           # Affiche les stats

# Autres fonctionnalités
./tools/rpg-prompt.sh "!roll 3d20"        # Lance des dés
./tools/rpg-prompt.sh "!createmonster Troll Geant 10"  # Crée un monstre
./tools/rpg-prompt.sh "!createitem Epee Arme 50"       # Crée un objet
```

**Documentation :** [DOCUMENTATION.md](plugins/rpg-irc-bot/DOCUMENTATION.md)

---

## 🔗 Intégration des Plugins avec la Base de Données

RefPerSys-in-C peut utiliser les plugins **db-explore** (Python) et **rpg-irc-bot** (Lua) ensemble pour créer, gérer et tester une **base de données RPG complète** avec MySQL/MariaDB.

### 🎯 Workflow d'Intégration

```
┌─────────────────────────────────────────────────────────────┐
│                    REFERSYS-IN-C                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐      ┌─────────────┐      ┌────────────┐ │
│  │   Lua       │      │   Python    │      │   MySQL    │ │
│  │ (rpg-irc)   │─────▶│ (db-explore)│─────▶│ (Base RPG)  │ │
│  └─────────────┘      └─────────────┘      └────────────┘ │
│       ▲                    ▲                    ▲          │
│       │                    │                    │          │
│  ┌────┴─────┐      ┌─────┴─────┐        ┌─────┴─────┐    │
│  │ Génération│      │ Persistance│        │ Stockage  │    │
│  │ de données│      │ des données│        │ des données│    │
│  └───────────┘      └─────────────┘        └───────────┘    │
└─────────────────────────────────────────────────────────────┘
```

### 📦 Scripts d'Intégration

| Script | Description |
|--------|-------------|
| `tools/db-explore.sh` | Wrapper pour le plugin Python db-explore |
| `tools/rpg-prompt.sh` | Wrapper pour le plugin Lua rpg-irc-bot |
| `tools/rpg-db-manager.sh` | Gestion intégrée RPG + Base de données |
| `tools/demo_rpg_database.sh` | **Démonstration complète** du système |

### 🚀 Démonstration Complète

Pour voir tout le système en action :

```bash
# Exécuter la démonstration complète
./tools/demo_rpg_database.sh
```

Ce script va :
1. ✅ Vérifier l'environnement (Lua, Python, MySQL)
2. ✅ Configurer la base de données (créer les tables RPG)
3. ✅ Générer des données avec Lua
4. ✅ Importer les données dans MySQL
5. ✅ Exécuter les tests automatiques
6. ✅ Afficher les statistiques

**Exemple de sortie :**
```
╔═══════════════════════════════════════════════════════════╗
║  🎮 Démonstration : RefPerSys + RPG + Base de Données     ║
╚═══════════════════════════════════════════════════════════╝

✅ Étape 1/6 : Vérification de l'environnement
✅ Étape 2/6 : Configuration de la base de données
✅ Étape 3/6 : Génération des données RPG avec Lua
✅ Étape 4/6 : Import des données dans MySQL
✅ Étape 5/6 : Exécution des tests
✅ Étape 6/6 : Statistiques de la base RPG

Total: 5 personnages, 5 monstres, 5 objets, 3 quêtes
```

---

## 📚 Documentation Complète

Pour une **documentation exhaustive et détaillée** sur l'utilisation des plugins et la création de la base de données RPG :

### **📖 Guide Principal**

> **[README_DB_RPG.md](README_DB_RPG.md)**

Ce guide complet (32+ Ko) couvre :
- ✅ Installation complète pas à pas
- ✅ Configuration de MySQL/MariaDB
- ✅ Architecture détaillée de la base RPG (4 tables)
- ✅ Toutes les commandes des plugins db-explore et rpg-irc-bot
- ✅ Intégration entre Python, Lua et RefPerSys
- ✅ 6 workflows complets
- ✅ Référence exhaustive des commandes
- ✅ Dépannage détaillé
- ✅ Sécurité et bonnes pratiques
- ✅ 3 exemples concrets avec code
- ✅ FAQ complète
- ✅ Annexes (schéma SQL, .gitignore, variables d'environnement)

### **📄 Documentation par Plugin**

| Plugin | Fichier | Description |
|--------|---------|-------------|
| db-explore | [INSTALL_blues-softwares.md](plugins/db-explore/INSTALL_blues-softwares.md) | Guide d'installation détaillé |
| db-explore | [COMMANDS_blues-softwares.md](plugins/db-explore/COMMANDS_blues-softwares.md) | Liste complète des commandes |
| db-explore | [README_blues-softwares.md](plugins/db-explore/README_blues-softwares.md) | Documentation principale |
| rpg-irc-bot | [DOCUMENTATION.md](plugins/rpg-irc-bot/DOCUMENTATION.md) | Documentation Lua RPG |
| rpg-irc-bot | [README.command_prompt.md](plugins/rpg-irc-bot/README.command_prompt.md) | Documentation du script Lua |

---

## 🎮 Exemples d'Utilisation

### Exemple 1 : Création Rapide d'une Base RPG

```bash
# 1. Créer les tables RPG
python3 plugins/db-explore/create_rpg_tables.py

# 2. Générer des données avec Lua
lua5.4 plugins/rpg-irc-bot/generate_sql_data.lua > /tmp/data.sql

# 3. Importer dans MySQL
python3 plugins/db-explore/import_rpg_data.py /tmp/data.sql

# 4. Vérifier
mysql -u jean-christophe -pCoding2029 -e "SELECT COUNT(*) FROM personnages;"
```

### Exemple 2 : Utilisation Quotidienne

```bash
# Créer un personnage
./tools/rpg-prompt.sh "!createplayer"

# Lister les personnages
./tools/rpg-db-manager.sh list-personnages

# Ajouter un monstre
./tools/rpg-prompt.sh "!createmonster Dragon Noir 15"

# Tester la base
python3 plugins/db-explore/test_rpg_database.py
```

### Exemple 3 : Simulation de Combat

```bash
python3 << EOF
import mysql.connector
from plugins.db-explore.config import DB_CONFIG

conn = mysql.connector.connect(**DB_CONFIG)
cursor = conn.cursor(dictionary=True)

cursor.execute("SELECT * FROM personnages ORDER BY RAND() LIMIT 1")
perso = cursor.fetchone()
cursor.execute("SELECT * FROM monstres ORDER BY RAND() LIMIT 1")
monstre = cursor.fetchone()

degats_perso = max(1, perso['force'] + perso['niveau'] - monstre['defense'])
degats_monstre = max(1, monstre['attaque'] - perso['agilite'])

if degats_perso >= degats_monstre:
    print(f"{perso['nom']} gagne contre {monstre['nom']}!")
    cursor.execute("UPDATE personnages SET experience = experience + %s WHERE nom = %s",
                  (monstre['experience_donnee'], perso['nom']))
else:
    print(f"{monstre['nom']} gagne contre {perso['nom']}!")

conn.commit()
cursor.close()
conn.close()
EOF
```

---

## 🐛 Dépannage

### Problèmes Courants

| Problème | Solution |
|----------|----------|
| MySQL ne démarre pas | `sudo systemctl restart mariadb` |
| Connexion MySQL refusée | Vérifier utilisateur/mot de passe |
| mysql-connector manquant | `sudo apt install python3-mysql.connector` |
| Lua non installé | `sudo apt install lua5.4 lua-filesystem` |
| RefPerSys ne compile pas | Vérifier toutes les dépendances |

### Vérification Complète

```bash
# Vérifier les dépendances
./install.sh

# Vérifier la compilation
make clean && make -j$(nproc)

# Vérifier MySQL
sudo systemctl status mariadb
mysql -u jean-christophe -p -e "SHOW DATABASES;"

# Vérifier Python
python3 -c "import mysql.connector; print('OK')"

# Vérifier Lua
lua5.4 -e "require('lfs'); print('OK')"
```

---

## 🔒 Sécurité

### Bonnes Pratiques

1. **Ne pas commiter les fichiers de configuration avec mots de passe** :
   ```bash
   echo "plugins/db-explore/config.py" >> .gitignore
   git rm --cached plugins/db-explore/config.py
   ```

2. **Utiliser des permissions MySQL limitées** :
   ```sql
   GRANT SELECT, INSERT, UPDATE, DELETE ON rpg_database.* 
       TO 'jean-christophe'@'localhost';
   ```

3. **Sauvegardes régulières** :
   ```bash
   mysqldump -u jean-christophe -pCoding2029 rpg_database > backup_$(date +%Y%m%d).sql
   ```

4. **Limiter l'accès distant** :
   ```ini
   # Dans /etc/mysql/mariadb.conf.d/50-server.cnf
   bind-address = 127.0.0.1
   ```

---

## 📊 Architecture de la Base de Données RPG

### Modèle Conceptuel

```
┌─────────────────────────────────────────────────────────────┐
│                        RPG_DATABASE                            │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐    │
│  │PERSONNAGES│  │ MONSTRES │  │  OBJETS  │  │  QUÊTES  │    │
│  ├──────────┤  ├──────────┤  ├──────────┤  ├──────────┤    │
│  │ id        │  │ id        │  │ id        │  │ id        │    │
│  │ nom       │  │ nom       │  │ nom       │  │ titre     │    │
│  │ classe    │  │ type      │  │ type      │  │ description│  │
│  │ niveau    │  │ niveau    │  │ valeur    │  │ exp_recomp │    │
│  │ pv        │  │ pv        │  │ rareté    │  │ or_recomp  │    │
│  │ force     │  │ attaque   │  └──────────┘  │ statut     │    │
│  │ agilite   │  │ defense   │                └──────────┘    │
│  │ intelligence│ └──────────┘                                │
│  │ or        │                                              │
│  │ experience│                                              │
│  └──────────┘                                              │
└─────────────────────────────────────────────────────────────┘
```

### Tables Disponibles

| Table | Description | Nombre de Colonnes |
|-------|-------------|-------------------|
| `personnages` | Personnages RPG avec stats | 10 |
| `monstres` | Monstres à combattre | 8 |
| `objets` | Objets à collectionner | 5 |
| `quetes` | Quêtes à accomplir | 6 |
| `utilisateurs` | Utilisateurs génériques | 3 |

---

## 🎯 Commandes Principales Résumées

### via Wrappers Shell

| Wrapper | Commande | Description |
|---------|----------|-------------|
| `db-explore.sh` | `create` | Crée la base |
| `db-explore.sh` | `setup` | Initialisation complète |
| `db-explore.sh` | `query` | Liste les données |
| `db-explore.sh` | `backup` | Sauvegarde |
| `rpg-prompt.sh` | `!help` | Affiche l'aide |
| `rpg-prompt.sh` | `!createplayer` | Crée un personnage |
| `rpg-prompt.sh` | `!roll 3d20` | Lance des dés |
| `rpg-db-manager.sh` | `setup` | Setup complet RPG + Base |
| `rpg-db-manager.sh` | `list-alles` | Liste tout |
| `demo_rpg_database.sh` | - | **Démonstration complète** |

### via Python

```bash
python3 plugins/db-explore/create_database.py    # Crée la base
python3 plugins/db-explore/create_rpg_tables.py   # Crée les tables RPG
python3 plugins/db-explore/import_rpg_data.py     # Importe les données
python3 plugins/db-explore/test_rpg_database.py   # Tests
```

### via Lua

```bash
lua5.4 plugins/rpg-irc-bot/command_prompt.lua      # Menu RPG
lua5.4 plugins/rpg-irc-bot/generate_sql_data.lua  # Génère SQL
```

### via MySQL

```bash
mysql -u jean-christophe -p rpg_database         # Connexion
mysqldump -u jean-christophe -p rpg_database > backup.sql  # Sauvegarde
```

---

## 🚀 Pour Aller Plus Loin

1. **Lire le guide complet** : [README_DB_RPG.md](README_DB_RPG.md)
2. **Explorer les plugins** : `plugins/db-explore/` et `plugins/rpg-irc-bot/`
3. **Personnaliser** : Modifier les scripts pour vos besoins
4. **Étendre** : Ajouter de nouvelles tables et fonctionnalités
5. **Contribuer** : Partager vos améliorations avec la communauté

---

## 📜 Licence

Ce projet est sous licence **GPL-3.0-or-later**.  
Voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

## 👤 Contact

- **Site officiel** : [https://blues-softwares.net](https://blues-softwares.net)
- **Email** : contact@blues-softwares.net
- **Dépôt** : [[RefPerSys/refpersys-in-c](https://github.com/jack-sparrow-code/refpersys-in-c)]((https://github.com/jack-sparrow-code/refpersys-in-c))

---

**© 2019-2026 The Reflective Persistent System Team**  
*RefPerSys-in-C : Puissance, Flexibilité, Extensibilité*


# Derniere mise a jour: 2026-07-18
