# 📚 RPG Command Prompt - Documentation Complète

> **Système RPG en Lua** - Basé sur [rpg-irc-bot](https://github.com/jack-sparrow-code/rpg-irc-bot)
> *Intégration RefPerSys-in-C*

---

## 📖 **Table des Matières**

1. [📋 Introduction](#-introduction)
2. [🛠 Installation](#-installation)
3. [🚀 Démarrage Rapide](#-démarrage-rapide)
4. [🎮 Système de Personnages](#-système-de-personnages)
5. [👹 Système de Monstres](#-système-de-monstres)
6. [🎲 Système de Dés](#-système-de-dés)
7. [💬 Commandes Disponibles](#-commandes-disponibles)
8. [📁 Structure des Fichiers](#-structure-des-fichiers)
9. [⚙ Configuration](#-configuration)
10. [🔧 Personnalisation](#-personnalisation)
11. [📊 Exemples d'Utilisation](#-exemples-dutilisation)
12. [🔗 Intégration avec RefPerSys](#-intégration-avec-refpersys)
13. [🛡 Dépannage](#-dépannage)
14. [📄 Licence et Crédits](#-licence-et-crédits)

---

## 📋 Introduction

**RPG Command Prompt** est une interface de commande en **Lua** qui implémente un système de jeu de rôle complet, inspiré du projet [rpg-irc-bot](https://github.com/jack-sparrow-code/rpg-irc-bot). Ce système permet de :

- ✅ Créer et gérer des personnages RPG avec des classes, attributs et sorts
- ✅ Créer et combattre des monstres avec des statistiques détaillées
- ✅ Lancer des dés pour divers jeux de table
- ✅ Sauvegarder et charger des données en format XML
- ✅ Utiliser une interface de commande interactive ou en mode script
- ✅ S'intégrer facilement avec RefPerSys-in-C

**Public cible** : Développeurs, joueurs de RPG, utilisateurs de RefPerSys

**Version** : 1.0.0

**Licence** : GPLv3

---

## 🛠 Installation

### Prérequis Système

| Composant | Version requise | Vérification |
|-----------|-----------------|--------------|
| Lua | 5.1 ou supérieur | `lua --version` |
| LuaFileSystem | 1.8.0 ou supérieur | `lua -e "require('lfs')"` |
| Système d'exploitation | Linux (Debian Trixie testé) | - |

### Installation sur Debian Trixie

#### Méthode 1 : Installation via apt (recommandée)

```bash
# Mettre à jour les paquets
sudo apt update

# Installer Lua 5.4
sudo apt install lua5.4

# Installer LuaFileSystem
sudo apt install lua-filesystem

# Vérifier l'installation
lua5.4 -e "print('Lua:', _VERSION)"
lua5.4 -e "require('lfs'); print('LuaFileSystem: OK')"
```

#### Méthode 2 : Installation via LuaRocks

```bash
# Installer LuaRocks
sudo apt install luarocks

# Installer LuaFileSystem
luarocks install luafilesystem
```

#### Méthode 3 : Installation manuelle (si nécessaire)

```bash
# Télécharger LuaFileSystem
wget https://github.com/ers35/lua_filesystem/archive/refs/tags/v1_8_0.tar.gz
.tar -xzf v1_8_0.tar.gz
cd lua_filesystem-1_8_0/

# Compiler et installer
make
sudo make install
```

---

## 🚀 Démarrage Rapide

### Étape 1 : Installer les dépendances

```bash
sudo apt install lua5.4 lua-filesystem
```

### Étape 2 : Vérifier la structure

```bash
# Depuis refpersys-in-c
ls -la plugins/rpg-irc-bot/
# Doit afficher : command_prompt.lua, README.command_prompt.md
```

### Étape 3 : Exécuter le RPG

```bash
# Méthode 1 : Via le wrapper
./tools/rpg-prompt.sh

# Méthode 2 : Directement avec Lua
lua5.4 plugins/rpg-irc-bot/command_prompt.lua

# Méthode 3 : Exécuter une commande spécifique
./tools/rpg-prompt.sh "!help"
```

### Étape 4 : Tester les fonctionnalités de base

```bash
# Afficher l'aide
./tools/rpg-prompt.sh "!help"

# Créer un personnage
./tools/rpg-prompt.sh "!createplayer"

# Lancer des dés
./tools/rpg-prompt.sh "!roll 3"

# Créer un monstre
./tools/rpg-prompt.sh "!createmonster Goblin werewolf 5"
```

---

## 🎮 Système de Personnages

### Classes Disponibles

Le système propose **7 classes de personnages** jouables, chacune avec ses caractéristiques uniques :

| Classe | Description | Énergie | Points forts | Points faibles |
|--------|-------------|---------|--------------|----------------|
| **Human** | Personnage polyvalent | 80 | Équilibré dans tous les domaines | Aucun domaine exceptionnel |
| **Mage** | Utilisateur de magie puissant | 100 | Magie élevée, bonne intelligence | Force et endurance faibles |
| **Elf** | Rapide et précis | 70 | Dextérité élevée, bonne magie | Force et endurance moyennes |
| **Dwarf** | Robuste et résistant | 90 | Force et endurance élevées | Magie faible |
| **Orc** | Brutal et résistant | 85 | Force très élevée | Magie très faible |
| **Troll** | Puissant mais lent | 110 | Force et endurance maximales | Dextérité et magie faibles |
| **Hobbit** | Agile et furtif | 60 | Dextérité maximale | Force et endurance faibles |

### Attributs

Chaque personnage possède **5 attributs principaux** qui déterminent ses capacités :

| Attribut | Description | Influence |
|----------|-------------|-----------|
| **Intelligence** | Capacité mentale | Puissance des sorts, compétences magiques |
| **Strength** | Force physique | Dégâts au combat, capacité de port |
| **Dexterity** | Agilité et précision | Précision des attaques, esquive |
| **Endurance** | Résistance physique | Points de vie, résistance aux effets |
| **Magic** | Puissance magique | Efficacité des sorts, résistance à la magie |

### Création d'un Personnage

La création se fait en **5 étapes** :

1. **Nom** : Choisissez un nom pour votre personnage (max 50 caractères)
2. **Classe** : Sélectionnez parmi les 7 classes disponibles
3. **Distribution des points** : Répartissez 30 points parmi vos 5 attributs
   - Chaque attribut a une valeur de base selon la classe
   - Vous pouvez ajouter des points pour améliorer un attribut
   - Exemple : Mage a Intelligence=8 de base, vous pouvez ajouter 12 points pour atteindre 20
4. **Niveau** : Choisissez un niveau entre 1 et 100
5. **Confirmation** : Validez ou annulez la création

#### Exemple de création

```
> !createplayer

==================================================
CREATION DE PERSONNAGE
==================================================

STEP 1/5: Character name
Enter name: Aragorn

STEP 2/5: Choose a class
Available classes:
  1. human - Versatile character
  2. mage - Powerful magic user
  3. elf - Fast and precise
  4. dwarf - Robust and resistant
  5. orc - Brutal and resistant
  6. troll - Powerful but slow
  7. hobbit - Agile and stealthy
Class: human

STEP 3/5: Attribute distribution
You have 30 points to distribute
  Intelligence (base: 5, max: 35, remaining: 30): 
  Value: 10
  Strength (base: 5, max: 35, remaining: 20): 
  Value: 15
  Dexterity (base: 5, max: 35, remaining: 5): 
  Value: 5
  Endurance (base: 5, max: 35, remaining: 0): 
  Value: 5
  Magic (base: 5, max: 35, remaining: 0): 
  Value: 5

STEP 4/5: Level
Level (1-100): 10

STEP 5/5: Confirmation
Name: Aragorn
Class: human
Level: 10
Attributes:
  Intelligence: 10
  Strength: 15
  Dexterity: 5
  Endurance: 5
  Magic: 5
Remaining points: 0
Create this character? (y/n): y

Character created and saved!
--------------------------------------------------
Character: Aragorn
Class: human (Level 10)
ID: 1784370924-1234
Attributes:
  Intelligence: 10
  Strength: 15
  Dexterity: 5
  Endurance: 5
  Magic: 5
Energy: 80/80
Spells: Basic Attack
Created: 2026-07-18 18:30:00
--------------------------------------------------
```

### Commandes de Personnages

| Commande | Description | Exemple |
|----------|-------------|---------|
| `!createplayer` | Démarrer la création interactive | `!createplayer` |
| `!listplayer` | Lister tous les personnages sauvegardés | `!listplayer` |
| `!getplayer <nom>` | Charger un personnage spécifique | `!getplayer Aragorn` |
| `!stats` | Afficher les stats du personnage actuel | `!stats` |

### Sorts par Classe

| Classe | Sorts de base |
|--------|---------------|
| Human | Basic Attack |
| Mage | Fireball, Lightning, Magic Shield |
| Elf | Precision Strike, Evasion, Nature Magic |
| Dwarf | Stunning Blow, Resist Magic, Stone Skin |
| Orc | Rage, Intimidation, Berserk |
| Troll | Regeneration, Smash, Tough Skin |
| Hobbit | Stealth, Lucky Strike, Quick Escape |

---

## 👹 Système de Monstres

### Classes de Monstres

Le système propose **6 classes de monstres** avec des caractéristiques uniques :

| Classe | Description | Santé | Dégâts | Armure |
|--------|-------------|-------|--------|--------|
| **Werewolf** | Rapide et puissant | 60 | 12 | 8 |
| **Vampire** | Immortel avec régénération | 70 | 15 | 10 |
| **Unicorn** | Magique avec soins | 65 | 10 | 5 |
| **Minotaur** | Puissant et résistant | 90 | 18 | 15 |
| **Phoenix** | Résurrection magique | 80 | 16 | 12 |
| **Kraken** | Monstre marin géant | 120 | 25 | 20 |

### Statistiques des Monstres

Les monstres possèdent les mêmes **5 attributs** que les personnages (Intelligence, Strength, Dexterity, Endurance, Magic), plus des statistiques de combat spécifiques :

- **Health** : Points de vie (augmente avec le niveau)
- **Damage** : Dégâts infligés (augmente avec le niveau)
- **Armor** : Réduction des dégâts (augmente avec le niveau)
- **Level** : Niveau du monstre (1-100)

Les statistiques sont calculées automatiquement selon la formule :
```
Health = base_health * (level / 10) * 1.5
Damage = base_damage * (level / 10) * 1.2
Armor = base_armor * (level / 10) * 1.1
Attributes = base_attribute * (level / 10) * 1.3
```

### Sorts Spéciaux par Classe

| Classe | Sorts spéciaux |
|--------|----------------|
| Werewolf | Howl, Bite, Regeneration |
| Vampire | Blood Drain, Mist Form, Immortality |
| Unicorn | Heal, Purify, Magic Horn |
| Minotaur | Charge, Gore, Roar |
| Phoenix | Fire Rebirth, Ash Cloud, Phoenix Flame |
| Kraken | Tentacle Strike, Ink Cloud, Crush |

### Commandes de Monstres

| Commande | Description | Exemple |
|----------|-------------|---------|
| `!createmonster <nom> <classe> <niveau>` | Créer un monstre | `!createmonster Dragon kraken 50` |
| `!listmonsters` | Lister tous les monstres | `!listmonsters` |
| `!getmonster <nom>` | Charger un monstre | `!getmonster Dragon` |

### Exemple de création de monstre

```
> !createmonster DragonNoir kraken 50

--------------------------------------------------
Monster: DragonNoir
Class: kraken (Level 50)
ID: 1784370924-5678
Health: 900/900
Damage: 187
Armor: 150
Attributes:
  Intelligence: 26
  Strength: 112
  Dexterity: 32
  Endurance: 112
  Magic: 32
Special Spells: Tentacle Strike, Ink Cloud, Crush
--------------------------------------------------

Monster created and saved!
```

---

## 🎲 Système de Dés

### Fonctionnement

Le système de dés permet de simuler des lancers de dés pour divers jeux de table. Il prend en charge :

- Lancer de **1 à 10 dés** simultanément (configurable)
- Dés à **6 faces** par défaut (configurable)
- Affichage **détaillé** de chaque dé et du total

### Commande

```
!roll <nombre_de_dés>
```

| Paramètre | Description | Valeur par défaut | Maximum |
|-----------|-------------|------------------|---------|
| nombre_de_dés | Nombre de dés à lancer | 1 | 10 |

### Exemples

```
> !roll
Rolled 4 (1d6)

> !roll 3
Rolled 3: [2, 5, 1] = Total: 8

> !roll 5
Rolled 5: [6, 3, 4, 2, 5] = Total: 20

> !roll 10
Rolled 10: [1, 6, 3, 4, 2, 5, 6, 3, 1, 4] = Total: 35
```

### Personnalisation

Vous pouvez modifier les paramètres dans le code source :

```lua
RPG.config = {
    max_dice_roll = 10,    -- Nombre maximum de dés
    -- ...
}
```

---

## 💬 Commandes Disponibles

### 📋 Liste Complète des Commandes

#### Commandes de Personnages

| Commande | Arguments | Description |
|----------|-----------|-------------|
| `!createplayer` | Aucun | Démarre la création interactive d'un personnage |
| `!listplayer` | Aucun | Liste tous les personnages sauvegardés |
| `!getplayer` | `<nom>` | Charge et affiche un personnage spécifique |
| `!stats` | Aucun | Affiche les statistiques du personnage actuel |

#### Commandes de Monstres

| Commande | Arguments | Description |
|----------|-----------|-------------|
| `!createmonster` | `<nom> <classe> <niveau>` | Crée un nouveau monstre |
| `!listmonsters` | Aucun | Liste tous les monstres sauvegardés |
| `!getmonster` | `<nom>` | Charge et affiche un monstre spécifique |

#### Commandes Utilitaires

| Commande | Arguments | Description |
|----------|-----------|-------------|
| `!roll` | `<nombre>` | Lance des dés (par défaut: 1d6) |
| `!hello` | Aucun | Affiche un message de bienvenue |
| `!ping` | Aucun | Teste la réactivité (affiche "Pong!") |
| `!help` | Aucun | Affiche l'aide complète |
| `!quit` | Aucun | Quitte le programme |

### Commandes sans préfixe `!`

Le système accepte les commandes **avec ou sans** le préfixe `!` :

```bash
# Ces commandes sont équivalentes
!roll 3
roll 3

!createplayer
createplayer

!help
help
```

---

## 📁 Structure des Fichiers

### Arborescence

```
refpersys-in-c/
├── tools/
│   └── rpg-prompt.sh              # Wrapper shell
├── plugins/
│   └── rpg-irc-bot/
│       ├── command_prompt.lua     # Script Lua principal (33,2 Ko)
│       ├── README.command_prompt.md  # Documentation spécifique
│       ├── DOCUMENTATION.md       # Ce fichier
│       ├── saves/                 # Répertoire des personnages (auto-créé)
│       │   ├── Gandalf.xml        # Exemple de personnage
│       │   ├── Aragorn.xml        # Exemple de personnage
│       │   └── ...
│       └── saves/monster/          # Répertoire des monstres (auto-créé)
│           ├── DragonNoir.xml     # Exemple de monstre
│           ├── Goblin.xml          # Exemple de monstre
│           └── ...
└── COMMANDS.md                   # Documentation générale
```

### Format des Fichiers de Sauvegarde

#### Personnage (XML)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<character>
    <id>1784370924-1234</id>
    <name>Gandalf</name>
    <class>mage</class>
    <level>25</level>
    <energy>100</energy>
    <energy_max>100</energy_max>
    <attributes>
        <intelligence>20</intelligence>
        <strength>5</strength>
        <dexterity>10</dexterity>
        <endurance>5</endurance>
        <magic>12</magic>
    </attributes>
    <spells>Fireball, Lightning, Magic Shield</spells>
    <created_at>1784370924</created_at>
    <updated_at>1784370924</updated_at>
</character>
```

#### Monstre (XML)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<monster>
    <id>1784370924-5678</id>
    <name>DragonNoir</name>
    <class>kraken</class>
    <level>50</level>
    <health>900</health>
    <health_max>900</health_max>
    <damage>187</damage>
    <armor>150</armor>
    <attributes>
        <intelligence>26</intelligence>
        <strength>112</strength>
        <dexterity>32</dexterity>
        <endurance>112</endurance>
        <magic>32</magic>
    </attributes>
    <spells>Tentacle Strike, Ink Cloud, Crush</spells>
    <created_at>1784370924</created_at>
    <updated_at>1784370924</updated_at>
</monster>
```

---

## ⚙ Configuration

### Configuration par Défaut

Le script utilise une configuration intégrée que vous pouvez modifier :

```lua
RPG.config = {
    saves_dir = "saves/",
    monster_saves_dir = "saves/monster/",
    max_character_name_length = 50,
    max_monster_name_length = 50,
    max_level = 100,
    starting_energy = 100,
    max_dice_roll = 10,
    character_classes = {
        available = {"human", "mage", "elf", "dwarf", "orc", "troll", "hobbit"},
        base_points = 30
    },
    monster_classes = {
        available = {"werewolf", "vampire", "unicorn", "minotaur", "phoenix", "kraken"}
    }
}
```

### Personnalisation de la Configuration

Pour modifier la configuration, éditez directement le fichier `command_prompt.lua` et modifiez les valeurs dans la table `RPG.config`.

---

## 🔧 Personnalisation

### Ajouter une Nouvelle Classe de Personnage

#### Étape 1 : Définir la classe

Ajoutez une nouvelle entrée dans `RPG.character_class_defs` :

```lua
RPG.character_class_defs.paladin = {
    name = "Paladin",
    description = "Holy warrior with healing abilities",
    base_attributes = {
        intelligence = 4,
        strength = 8,
        dexterity = 5,
        endurance = 7,
        magic = 6
    },
    base_spells = {"Holy Strike", "Divine Healing", "Blessing"},
    base_energy = 90,
    base_energy_max = 90
}
```

#### Étape 2 : Ajouter à la liste des classes disponibles

```lua
RPG.config.character_classes.available = {
    "human", "mage", "elf", "dwarf", "orc", "troll", "hobbit", "paladin"
}
```

#### Étape 3 : Tester

```bash
./tools/rpg-prompt.sh "!createplayer"
# La nouvelle classe "paladin" devrait apparaître dans la liste
```

### Ajouter une Nouvelle Classe de Monstre

Même principe que pour les personnages :

```lua
-- Ajouter la définition
RPG.monster_class_defs.demon = {
    name = "Demon",
    description = "Dark creature from hell",
    base_health = 85,
    base_damage = 20,
    base_armor = 14,
    base_attributes = {
        intelligence = 9,
        strength = 7,
        dexterity = 6,
        endurance = 8,
        magic = 10
    },
    base_spells = {"Hellfire", "Darkness", "Soul Drain"}
}

-- Ajouter à la liste
RPG.config.monster_classes.available = {
    "werewolf", "vampire", "unicorn", "minotaur", "phoenix", "kraken", "demon"
}
```

### Modifier les Formules de Calcul

Vous pouvez modifier les formules utilisées pour calculer les statistiques des monstres :

```lua
-- Dans la fonction RPG.Monster:create()
monster.health = class_def.base_health * (level / 10) * 1.5
monster.damage = class_def.base_damage * (level / 10) * 1.2
monster.armor = class_def.base_armor * (level / 10) * 1.1

-- Modifiez les multiplicateurs pour ajuster la difficulté
monster.health = class_def.base_health * (level / 10) * 2.0  -- Monstres plus résistants
monster.damage = class_def.base_damage * (level / 10) * 1.5  -- Monstres plus dangereux
```

---

## 📊 Exemples d'Utilisation

### Scénario 1 : Création d'un Personnage et d'un Monstre

```bash
# Démarrer le mode interactif
./tools/rpg-prompt.sh

# Dans le prompt
> !createplayer
# Suivre les étapes pour créer un personnage

> !createmonster Dragon kraken 30

> !listplayer
> !listmonsters
```

### Scénario 2 : Lancer des Dés pour un Jeu

```bash
# Lancer 3 dés
./tools/rpg-prompt.sh "!roll 3"
# Output: Rolled 3: [4, 2, 6] = Total: 12

# Lancer 1 dé (par défaut)
./tools/rpg-prompt.sh "!roll"
# Output: Rolled 3 (1d6)
```

### Scénario 3 : Gestion des Personnages

```bash
# Créer plusieurs personnages
./tools/rpg-prompt.sh "!createplayer"  # Gandalf
./tools/rpg-prompt.sh "!createplayer"  # Aragorn

# Lister tous les personnages
./tools/rpg-prompt.sh "!listplayer"

# Charger un personnage spécifique
./tools/rpg-prompt.sh "!getplayer Gandalf"

# Afficher ses statistiques
./tools/rpg-prompt.sh "!stats"
```

### Scénario 4 : Combat Simulé

```bash
# Créer un personnage puissant
./tools/rpg-prompt.sh "!createplayer"
# Nom: Warrior, Classe: human, Attributs: Strength=20, etc.

# Créer un monstre
./tools/rpg-prompt.sh "!createmonster Goblin werewolf 10"

# Lancer des dés pour simuler un combat
./tools/rpg-prompt.sh "!roll 20"  # Attaque du personnage
./tools/rpg-prompt.sh "!roll 10"  # Attaque du monstre
```

### Scénario 5 : Utilisation en Script

```bash
#!/bin/bash
# Script de test RPG

# Créer 5 personnages aléatoires
for i in {1..5}; do
    echo "Création du personnage $i..."
    echo "!createplayer" | lua plugins/rpg-irc-bot/command_prompt.lua
    echo ""
done

# Créer 3 monstres
./tools/rpg-prompt.sh "!createmonster Monster1 werewolf 5"
./tools/rpg-prompt.sh "!createmonster Monster2 vampire 10"
./tools/rpg-prompt.sh "!createmonster Monster3 kraken 20"

# Lister tout
./tools/rpg-prompt.sh "!listplayer"
./tools/rpg-prompt.sh "!listmonsters"
```

---

## 🔗 Intégration avec RefPerSys

### Méthode 1 : Appel Direct depuis C

Dans votre code C (par exemple `src/main_rps.c`), vous pouvez appeler le script Lua :

```c
#include <stdlib.h>

void call_rpg_command(const char *command) {
    char buffer[256];
    snprintf(buffer, sizeof(buffer), 
             "lua5.4 plugins/rpg-irc-bot/command_prompt.lua \"%s\"", 
             command);
    system(buffer);
}

// Exemple d'utilisation
call_rpg_command("!roll 3");
call_rpg_command("!createplayer");
```

### Méthode 2 : Via le Wrapper Shell

Utilisez le script `tools/rpg-prompt.sh` pour une intégration plus propre :

```c
void call_rpg_wrapper(const char *args) {
    char buffer[256];
    snprintf(buffer, sizeof(buffer), "./tools/rpg-prompt.sh %s", args);
    system(buffer);
}

// Exemple
call_rpg_wrapper("!createmonster Orc werewolf 10");
```

### Méthode 3 : Communication Inter-Processus (Avancé)

Pour une intégration plus poussée, vous pouvez utiliser des **pipes nommés** ou **sockets** :

```lua
-- Dans command_prompt.lua, ajouter le support des pipes
local function read_from_pipe()
    -- Lire depuis stdin
    return io.read("*l")
end
```

Puis depuis C :

```c
// Écrire dans un pipe vers Lua
FILE *pipe = popen("lua plugins/rpg-irc-bot/command_prompt.lua", "w");
fprintf(pipe, "!roll 3\n");
fflush(pipe);
pclose(pipe);
```

### Méthode 4 : Intégration comme Module

Pour une intégration complète, vous pourriez :

1. Compiler Lua en bibliothèque partagée
2. L'appeler directement depuis le code C de RefPerSys
3. Passer des structures de données entre C et Lua

Cette méthode nécessite une bonne connaissance de l'API C de Lua.

---

## 🛡 Dépannage

### Problèmes Courants et Solutions

#### ❌ Problème : Lua non trouvé

**Symptôme** :
```
ERREUR: Lua n'est pas installé.
```

**Solution** :
```bash
sudo apt install lua5.4
```

**Vérification** :
```bash
which lua5.4
lua5.4 --version
```

---

#### ❌ Problème : LuaFileSystem manquant

**Symptôme** :
```
error: module 'lfs' not found:
```

**Solution** :
```bash
sudo apt install lua-filesystem
```

**Vérification** :
```bash
lua5.4 -e "require('lfs'); print('OK')"
```

---

#### ❌ Problème : Permission refusée sur les répertoires

**Symptôme** :
```
Cannot create directory: Permission denied
```

**Solution** :
```bash
# Donner les permissions
chmod -R u+rw plugins/rpg-irc-bot/

# Ou créer les répertoires manuellement
mkdir -p plugins/rpg-irc-bot/saves/
mkdir -p plugins/rpg-irc-bot/saves/monster/
```

---

#### ❌ Problème : Script non trouvé

**Symptôme** :
```
ERREUR: Le script RPG n'est pas trouvé
```

**Solution** :
```bash
# Vérifier que le script existe
ls -la plugins/rpg-irc-bot/command_prompt.lua

# Si non, le créer
# (le fichier devrait déjà être là après l'installation)
```

---

#### ❌ Problème : Erreur de parsing XML

**Symptôme** :
```
nil value in character loading
```

**Solution** :
- Vérifiez que le fichier XML est bien formé
- Le parser utilise des patterns simples, assurez-vous que le format correspond
- Exemple de format valide dans la section [Structure des Fichiers](#-structure-des-fichiers)

---

#### ❌ Problème : Classe non reconnue

**Symptôme** :
```
Invalid class. Defaulting to human.
```

**Solution** :
- Vérifiez l'orthographe de la classe
- Utilisez uniquement les classes disponibles : `human`, `mage`, `elf`, `dwarf`, `orc`, `troll`, `hobbit`
- Pour les monstres : `werewolf`, `vampire`, `unicorn`, `minotaur`, `phoenix`, `kraken`

---

### Messages d'Erreur et Diagnostics

| Message | Cause | Solution |
|---------|-------|----------|
| `ERREUR: Lua n'est pas installé` | Lua non installé | `sudo apt install lua5.4` |
| `module 'lfs' not found` | LuaFileSystem manquant | `sudo apt install lua-filesystem` |
| `No such file or directory` | Répertoire manquant | Créer `saves/` et `saves/monster/` |
| `Invalid class` | Classe non valide | Vérifier l'orthographe |
| `Permission denied` | Problème de permissions | `chmod -R u+rw plugins/` |

---

## 📄 Licence et Crédits

### Licence

Ce projet est distribué sous la **licence GNU General Public License v3.0 (GPLv3)**.

**Conditions principales** :
- ✅ Libre à utiliser, modifier et distribuer
- ✅ Le code source doit être disponible lors de la distribution
- ❌ Pas de garantie
- ❌ Les versions modifiées doivent rester sous GPLv3

**Texte complet** : Voir le fichier [LICENSE](https://github.com/jack-sparrow-code/rpg-irc-bot/blob/main/LICENSE) du projet original.

### Crédits

| Rôle | Nom | Contact |
|------|-----|---------|
| **Auteur original** | Major-GHZ | [GitHub](https://github.com/Major-GHZ) |
| **Mainteneur** | jack-sparrow-code | [GitHub](https://github.com/jack-sparrow-code) |
| **Adaptation Lua** | Jean-Christophe Énée | jean-christophe@blues-softwares.net |
| **Projet parent** | rpg-irc-bot | [GitHub](https://github.com/jack-sparrow-code/rpg-irc-bot) |

### Contributions

Les contributions sont les bienvenues ! Pour contribuer :

1. **Fork** le projet
2. Créez une branche (`git checkout -b feature/ma-fonctionnalité`)
3. Commitez vos changements (`git commit -m 'Ajout de ma fonctionnalité'`)
4. Poussez vers la branche (`git push origin feature/ma-fonctionnalité`)
5. Ouvrez une Pull Request

### Remerciements

- La communauté **Lua** pour ce langage excellent
- Les développeurs du **protocole IRC** pour la base
- Tous les **contributeurs et testeurs** pour leurs retours
- Les passionnés de **RPG** pour l'inspiration
- La **Free Software Foundation** pour la licence GPLv3

---

## 🎯 Résumé des Commandes

| Commande | Description | Catégorie |
|----------|-------------|----------|
| `!createplayer` | Créer un personnage | Personnages |
| `!listplayer` | Lister les personnages | Personnages |
| `!getplayer <nom>` | Charger un personnage | Personnages |
| `!stats` | Stats du personnage | Personnages |
| `!createmonster <n> <c> <l>` | Créer un monstre | Monstres |
| `!listmonsters` | Lister les monstres | Monstres |
| `!getmonster <nom>` | Charger un monstre | Monstres |
| `!roll <n>` | Lancer des dés | Utilitaires |
| `!hello` | Salutation | Utilitaires |
| `!ping` | Test de connexion | Utilitaires |
| `!help` | Aide | Utilitaires |
| `!quit` | Quitter | Utilitaires |

---

## 📞 Support

Pour toute question ou problème :

- **Documentation** : Ce fichier (`DOCUMENTATION.md`)
- **Projet original** : [rpg-irc-bot](https://github.com/jack-sparrow-code/rpg-irc-bot)
- **RefPerSys** : [refpersys.org](http://refpersys.org/)
- **Email** : jean-christophe@blues-softwares.net

---

## 🏁 Conclusion

**RPG Command Prompt** vous offre un système RPG complet et flexible, directement utilisable depuis la ligne de commande ou intégré avec **RefPerSys-in-C**. Que vous soyez un joueur cherchant à gérer vos personnages ou un développeur souhaitant étendre RefPerSys, ce système vous fournit toutes les bases nécessaires.

**Bon jeu !** 🎮✨

---

*Documentation générée le 18 juillet 2026*
*© 2026 Jean-Christophe Énée - Blues Softwares*
