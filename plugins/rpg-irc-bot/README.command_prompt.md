# RPG Command Prompt - Lua

> **Interface de commande Lua pour RPG** - Basé sur [rpg-irc-bot](https://github.com/jack-sparrow-code/rpg-irc-bot)

---

## 📌 À propos

Ce projet fournit une **interface de commande en Lua** pour gérer un jeu de rôle (RPG) en ligne de commande. Il est inspiré du bot IRC [rpg-irc-bot](https://github.com/jack-sparrow-code/rpg-irc-bot) mais adapté pour une utilisation locale sans nécessiter de connexion IRC.

**Fonctionnalités :**
- ✅ Création interactive de personnages RPG
- ✅ Gestion des monstres
- ✅ Système de lancer de dés
- ✅ Sauvegarde/Chargement en XML
- ✅ Interface de commande interactive
- ✅ Exécution en mode script

---

## 🛠 Prérequis

### Système
- **Lua 5.1 ou supérieur** (testé avec Lua 5.4)
- **LuaFileSystem** (pour la gestion des fichiers)

### Installation des dépendances

#### Sur Debian/Ubuntu
```bash
sudo apt install lua5.4 liblua5.4-dev
sudo apt install lua-lfs  # LuaFileSystem
```

#### Via LuaRocks
```bash
# Installer LuaRocks
sudo apt install luarocks

# Installer LuaFileSystem
luarocks install luafilesystem
```

---

## 💻 Installation

### Méthode 1 : Clone complet du dépôt
```bash
# Depuis refpersys-in-c
cd /home/jean-christophe/Documents/codes/refpersys-in-c
mkdir -p plugins
cd plugins
git clone https://github.com/jack-sparrow-code/rpg-irc-bot.git
cd rpg-irc-bot
```

### Méthode 2 : Copier uniquement le script de commande
```bash
# Créer la structure
mkdir -p plugins/rpg-irc-bot/saves/monster

# Copier le script command_prompt.lua
# (le fichier est déjà créé dans plugins/rpg-irc-bot/)
```

### Méthode 3 : Téléchargement direct
```bash
wget https://raw.githubusercontent.com/jack-sparrow-code/rpg-irc-bot/main/modules/character.lua -P plugins/rpg-irc-bot/modules/
# ... (télécharger les autres fichiers si nécessaire)
```

---

## 🚀 Utilisation

### Mode interactif (recommandé)

```bash
# Depuis le répertoire plugins/rpg-irc-bot
lua command_prompt.lua
```

Ou depuis la racine de refpersys-in-c :
```bash
lua plugins/rpg-irc-bot/command_prompt.lua
```

### Mode script (exécuter une commande et quitter)

```bash
# Créer un personnage
lua plugins/rpg-irc-bot/command_prompt.lua "!createplayer"

# Lister les personnages
lua plugins/rpg-irc-bot/command_prompt.lua "!listplayer"

# Créer un monstre
lua plugins/rpg-irc-bot/command_prompt.lua "!createmonster Dragon kraken 50"

# Lancer des dés
lua plugins/rpg-irc-bot/command_prompt.lua "!roll 3"
```

---

## 🎮 Commandes disponibles

### 🎭 Commandes de personnages

| Commande | Description |
|----------|-------------|
| `!createplayer` | Démarrer la création interactive d'un personnage |
| `!listplayer` | Lister tous les personnages sauvegardés |
| `!getplayer <nom>` | Charger et afficher un personnage spécifique |
| `!stats` | Afficher les statistiques du personnage actuel |

### 👹 Commandes de monstres

| Commande | Description |
|----------|-------------|
| `!createmonster <nom> <classe> <niveau>` | Créer un nouveau monstre |
| `!listmonsters` | Lister tous les monstres sauvegardés |
| `!getmonster <nom>` | Charger et afficher un monstre spécifique |

### 🎲 Commandes utilitaires

| Commande | Description |
|----------|-------------|
| `!roll <nombre>` | Lancer des dés (par défaut: 1d6, max 10 dés) |
| `!hello` | Salutation amicale |
| `!ping` | Tester la connexion |
| `!help` | Afficher l'aide |
| `!quit` | Quitter le programme |

---

## 📖 Exemples d'utilisation

### Exemple 1 : Création d'un personnage

```
> !createplayer

==================================================
CREATION DE PERSONNAGE
==================================================

STEP 1/5: Character name
Enter name: Gandalf

STEP 2/5: Choose a class
Available classes:
  1. human - Versatile character
  2. mage - Powerful magic user
  3. elf - Fast and precise
  4. dwarf - Robust and resistant
  5. orc - Brutal and resistant
  6. troll - Powerful but slow
  7. hobbit - Agile and stealthy
Class: mage

STEP 3/5: Attribute distribution
You have 30 points to distribute
  Intelligence (base: 8, max: 38, remaining: 30): 
  Value: 20
  Strength (base: 2, max: 32, remaining: 22): 
  Value: 5
  Dexterity (base: 4, max: 34, remaining: 17): 
  Value: 10
  Endurance (base: 3, max: 33, remaining: 7): 
  Value: 5
  Magic (base: 10, max: 40, remaining: 2): 
  Value: 12

STEP 4/5: Level
Level (1-100): 25

STEP 5/5: Confirmation
Name: Gandalf
Class: mage
Level: 25
Attributes:
  Intelligence: 20
  Strength: 5
  Dexterity: 10
  Endurance: 5
  Magic: 12
Remaining points: 2
Create this character? (y/n): y

Character created and saved!
--------------------------------------------------
Character: Gandalf
Class: mage (Level 25)
ID: 1784370924-1234
Attributes:
  Intelligence: 20
  Strength: 5
  Dexterity: 10
  Endurance: 5
  Magic: 12
Energy: 100/100
Spells: Fireball, Lightning, Magic Shield
Created: 2026-07-18 18:00:00
--------------------------------------------------
```

### Exemple 2 : Création d'un monstre

```
> !createmonster DragonNoir kraken 50

==================================================
MONSTER CREATED SUCCESSFULLY
==================================================
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

### Exemple 3 : Lancer des dés

```
> !roll 5
Rolled 5: [3, 6, 1, 4, 2] = Total: 16

> !roll
Rolled 4 (1d6)
```

### Exemple 4 : Lister les personnages et monstres

```
> !listplayer
==================================================
SAVED CHARACTERS
==================================================
Found 1 character(s):
  1. Gandalf (mage, Level 25)

> !listmonsters
==================================================
SAVED MONSTERS
==================================================
Found 1 monster(s):
  1. DragonNoir (kraken, Level 50)
```

---

## 📁 Structure des fichiers

```
plugins/rpg-irc-bot/
├── command_prompt.lua      # Script principal (créé)
├── saves/                  # Personnages sauvegardés (auto-créé)
│   ├── Gandalf.xml
│   └── ...
└── saves/monster/          # Monstres sauvegardés (auto-créé)
    ├── DragonNoir.xml
    └── ...
```

---

## 📊 Classes disponibles

### Classes de personnages (7)

| Classe | Description | Énergie de base | Sorts |
|--------|-------------|----------------|-------|
| **Human** | Personnage polyvalent | 80 | Basic Attack |
| **Mage** | Utilisateur de magie puissant | 100 | Fireball, Lightning, Magic Shield |
| **Elf** | Rapide et précis | 70 | Precision Strike, Evasion, Nature Magic |
| **Dwarf** | Robuste et résistant | 90 | Stunning Blow, Resist Magic, Stone Skin |
| **Orc** | Brutal et résistant | 85 | Rage, Intimidation, Berserk |
| **Troll** | Puissant mais lent | 110 | Regeneration, Smash, Tough Skin |
| **Hobbit** | Agile et furtif | 60 | Stealth, Lucky Strike, Quick Escape |

### Classes de monstres (6)

| Classe | Description | Santé de base | Sorts |
|--------|-------------|--------------|-------|
| **Werewolf** | Rapide et puissant | 60 | Howl, Bite, Regeneration |
| **Vampire** | Immortel avec régénération | 70 | Blood Drain, Mist Form, Immortality |
| **Unicorn** | Magique avec soins | 65 | Heal, Purify, Magic Horn |
| **Minotaur** | Puissant et résistant | 90 | Charge, Gore, Roar |
| **Phoenix** | Résurrection magique | 80 | Fire Rebirth, Ash Cloud, Phoenix Flame |
| **Kraken** | Monstre marin géant | 120 | Tentacle Strike, Ink Cloud, Crush |

---

## ⚙ Configuration

Vous pouvez personnaliser la configuration en modifiant directement le code dans `command_prompt.lua` :

```lua
RPG.config = {
    saves_dir = "saves/",
    monster_saves_dir = "saves/monster/",
    max_character_name_length = 50,
    max_monster_name_length = 50,
    max_level = 100,
    starting_energy = 100,
    max_dice_roll = 10
}
```

---

## 🔧 Personnalisation

### Ajouter une nouvelle classe de personnage

Ajoutez une nouvelle entrée dans `RPG.character_class_defs` :

```lua
paladin = {
    name = "Paladin",
    description = "Holy warrior with healing abilities",
    base_attributes = {intelligence = 4, strength = 8, dexterity = 5, endurance = 7, magic = 6},
    base_spells = {"Holy Strike", "Divine Healing", "Blessing"},
    base_energy = 90,
    base_energy_max = 90
}
```

Puis ajoutez-la à la liste des classes disponibles :

```lua
character_classes = {
    available = {"human", "mage", "elf", "dwarf", "orc", "troll", "hobbit", "paladin"},
    base_points = 30
}
```

### Ajouter une nouvelle classe de monstre

Même principe avec `RPG.monster_class_defs` et `RPG.config.monster_classes.available`.

---

## 🛡 Sauvegarde des données

### Format de sauvegarde

Les personnages et monstres sont sauvegardés au format **XML** :

**Personnage (Gandalf.xml)** :
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

**Monstre (DragonNoir.xml)** :
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

### Emplacement des sauvegardes

Par défaut :
- Personnages : `plugins/rpg-irc-bot/saves/`
- Monstres : `plugins/rpg-irc-bot/saves/monster/`

---

## 🎯 Intégration avec RefPerSys

Ce script peut être intégré avec **RefPerSys-in-C** de plusieurs manières :

### Méthode 1 : Appel direct depuis C

Utilisez `system()` ou `popen()` dans le code C pour appeler Lua :

```c
// Dans src/main_rps.c
system("lua plugins/rpg-irc-bot/command_prompt.lua '!roll 3'");
```

### Méthode 2 : Wrapper shell

Créez un script shell pour simplifier l'appel :

```bash
#!/bin/bash
# tools/rpg-prompt.sh
cd "$(dirname "$0")/../plugins/rpg-irc-bot"
lua command_prompt.lua "$@"
```

Puis depuis RefPerSys :
```bash
./tools/rpg-prompt.sh "!createplayer"
```

### Méthode 3 : Communication inter-processus

Pour une intégration plus poussée, utilisez des sockets ou des pipes nommés pour communiquer entre RefPerSys (C) et le script Lua.

---

## 🐛 Dépannage

### Problème : Lua non trouvé
```bash
# Installer Lua
sudo apt install lua5.4
```

### Problème : LuaFileSystem manquant
```bash
# Installer via LuaRocks
luarocks install luafilesystem

# Ou via apt
sudo apt install lua-lfs
```

### Problème : Erreur de parsing XML
Le script utilise un parsing XML simple basé sur des patterns Lua. Pour des fichiers XML complexes, envisagez d'utiliser une bibliothèque comme `lua-expat` ou `luaxml`.

### Problème : Répertoires de sauvegarde non créés
Le script crée automatiquement les répertoires `saves/` et `saves/monster/` au premier lancement.

---

## 📚 Documentation originale

Le projet original [rpg-irc-bot](https://github.com/jack-sparrow-code/rpg-irc-bot) contient :

- `main.lua` - Point d'entrée du bot IRC
- `config.lua` - Configuration complète
- `modules/` - Modules Lua pour les fonctionnalités RPG
  - `character.lua` - Système de personnages
  - `character_classes.lua` - Définitions des classes
  - `dice.lua` - Système de dés
  - `monster_creation.lua` - Création de monstres
  - `irc/bot.lua` - Logique du bot IRC

---

## 🤝 Contribution

Les contributions sont les bienvenues ! Vous pouvez :

1. **Améliorer le script** : Ajouter de nouvelles commandes, classes, ou fonctionnalités
2. **Corriger des bugs** : Rapporter ou corriger les problèmes
3. **Améliorer la documentation** : Clarifier les explications
4. **Ajouter des tests** : Créer des tests unitaires

---

## 📄 Licence

Ce script est distribué sous la **licence GPLv3**, comme le projet original [rpg-irc-bot](https://github.com/jack-sparrow-code/rpg-irc-bot).

Voir le fichier [LICENSE](https://github.com/jack-sparrow-code/rpg-irc-bot/blob/main/LICENSE) pour plus de détails.

---

## 📬 Contact

- **Auteur original** : Major-GHZ / jack-sparrow-code
- **Adaptation** : Jean-Christophe Énée (Jitsukai)
- **Email** : jean-christophe@blues-softwares.net
- **Site** : [blues-softwares.net](https://blues-softwares.net)

---

## 🎉 Exemples rapides

```bash
# Démarrer le mode interactif
lua plugins/rpg-irc-bot/command_prompt.lua

# Créer un personnage rapidement
lua plugins/rpg-irc-bot/command_prompt.lua "!createplayer"

# Lancer 3 dés
lua plugins/rpg-irc-bot/command_prompt.lua "!roll 3"

# Voir l'aide
lua plugins/rpg-irc-bot/command_prompt.lua "!help"
```

**Amusez-vous bien avec votre RPG en Lua !** 🎮✨
