--[[
================================================================================
RPG Command Prompt - Interface de commande Lua pour RPG
Basé sur : https://github.com/jack-sparrow-code/rpg-irc-bot

Ce script fournit une interface de commande simplifiée pour gérer un RPG
en ligne de commande, inspiré du bot IRC mais adapté pour un usage local.

Auteur : Adapté du projet rpg-irc-bot
Licence : GPLv3
================================================================================
]]

--============================================================================--
-- Configuration
--============================================================================--

local RPG = {}
RPG.version = "1.0.0"
RPG.name = "RPG Command Prompt"

-- Configuration par défaut
RPG.config = {
    saves_dir = "saves/",
    monster_saves_dir = "saves/monster/",
    max_character_name_length = 50,
    max_monster_name_length = 50,
    max_level = 100,
    starting_energy = 100,
    max_dice_roll = 10,
    -- Classes de personnages disponibles
    character_classes = {
        available = {"human", "mage", "elf", "dwarf", "orc", "troll", "hobbit"},
        base_points = 30
    },
    -- Classes de monstres disponibles
    monster_classes = {
        available = {"werewolf", "vampire", "unicorn", "minotaur", "phoenix", "kraken"}
    }
}

-- Définitions des classes de personnages
RPG.character_class_defs = {
    human = {
        name = "Human",
        description = "Versatile character",
        base_attributes = {intelligence = 5, strength = 5, dexterity = 5, endurance = 5, magic = 5},
        base_spells = {"Basic Attack"},
        base_energy = 80,
        base_energy_max = 80
    },
    mage = {
        name = "Mage",
        description = "Powerful magic user",
        base_attributes = {intelligence = 8, strength = 2, dexterity = 4, endurance = 3, magic = 10},
        base_spells = {"Fireball", "Lightning", "Magic Shield"},
        base_energy = 100,
        base_energy_max = 100
    },
    elf = {
        name = "Elf",
        description = "Fast and precise",
        base_attributes = {intelligence = 7, strength = 3, dexterity = 8, endurance = 4, magic = 6},
        base_spells = {"Precision Strike", "Evasion", "Nature Magic"},
        base_energy = 70,
        base_energy_max = 70
    },
    dwarf = {
        name = "Dwarf",
        description = "Robust and resistant",
        base_attributes = {intelligence = 4, strength = 8, dexterity = 3, endurance = 10, magic = 2},
        base_spells = {"Stunning Blow", "Resist Magic", "Stone Skin"},
        base_energy = 90,
        base_energy_max = 90
    },
    orc = {
        name = "Orc",
        description = "Brutal and resistant",
        base_attributes = {intelligence = 3, strength = 10, dexterity = 5, endurance = 8, magic = 1},
        base_spells = {"Rage", "Intimidation", "Berserk"},
        base_energy = 85,
        base_energy_max = 85
    },
    troll = {
        name = "Troll",
        description = "Powerful but slow",
        base_attributes = {intelligence = 2, strength = 12, dexterity = 2, endurance = 12, magic = 0},
        base_spells = {"Regeneration", "Smash", "Tough Skin"},
        base_energy = 110,
        base_energy_max = 110
    },
    hobbit = {
        name = "Hobbit",
        description = "Agile and stealthy",
        base_attributes = {intelligence = 6, strength = 2, dexterity = 10, endurance = 3, magic = 4},
        base_spells = {"Stealth", "Lucky Strike", "Quick Escape"},
        base_energy = 60,
        base_energy_max = 60
    }
}

-- Définitions des classes de monstres
RPG.monster_class_defs = {
    werewolf = {
        name = "Werewolf",
        description = "Fast and powerful",
        base_health = 60,
        base_damage = 12,
        base_armor = 8,
        base_attributes = {intelligence = 6, strength = 8, dexterity = 7, endurance = 7, magic = 2},
        base_spells = {"Howl", "Bite", "Regeneration"}
    },
    vampire = {
        name = "Vampire",
        description = "Immortal with regeneration",
        base_health = 70,
        base_damage = 15,
        base_armor = 10,
        base_attributes = {intelligence = 8, strength = 6, dexterity = 8, endurance = 6, magic = 8},
        base_spells = {"Blood Drain", "Mist Form", "Immortality"}
    },
    unicorn = {
        name = "Unicorn",
        description = "Magical with healing",
        base_health = 65,
        base_damage = 10,
        base_armor = 5,
        base_attributes = {intelligence = 7, strength = 5, dexterity = 8, endurance = 6, magic = 10},
        base_spells = {"Heal", "Purify", "Magic Horn"}
    },
    minotaur = {
        name = "Minotaur",
        description = "Powerful and resistant",
        base_health = 90,
        base_damage = 18,
        base_armor = 15,
        base_attributes = {intelligence = 3, strength = 12, dexterity = 4, endurance = 12, magic = 1},
        base_spells = {"Charge", "Gore", "Roar"}
    },
    phoenix = {
        name = "Phoenix",
        description = "Magical rebirth",
        base_health = 80,
        base_damage = 16,
        base_armor = 12,
        base_attributes = {intelligence = 8, strength = 6, dexterity = 6, endurance = 7, magic = 9},
        base_spells = {"Fire Rebirth", "Ash Cloud", "Phoenix Flame"}
    },
    kraken = {
        name = "Kraken",
        description = "Giant sea monster",
        base_health = 120,
        base_damage = 25,
        base_armor = 20,
        base_attributes = {intelligence = 4, strength = 15, dexterity = 5, endurance = 15, magic = 5},
        base_spells = {"Tentacle Strike", "Ink Cloud", "Crush"}
    }
}

--============================================================================--
-- Fonctions utilitaires
--============================================================================--

-- Vérifier et créer les répertoires de sauvegarde
function RPG.ensure_saves_directories()
    local lfs = require("lfs")
    
    -- Créer le répertoire de sauvegarde des personnages
    if not lfs.attributes(RPG.config.saves_dir) then
        os.execute("mkdir -p " .. RPG.config.saves_dir)
    end
    
    -- Créer le répertoire de sauvegarde des monstres
    if not lfs.attributes(RPG.config.monster_saves_dir) then
        os.execute("mkdir -p " .. RPG.config.monster_saves_dir)
    end
end

-- Générer un ID unique
function RPG.generate_id()
    return os.time() .. "-" .. math.random(1000, 9999)
end

-- Clamp une valeur entre min et max
function RPG.clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

-- Copier une table (shallow copy)
function RPG.table_copy(t)
    local new = {}
    for k, v in pairs(t) do
        new[k] = v
    end
    return new
end

-- Concatenation de table avec séparateur
function RPG.table_concat(t, sep)
    sep = sep or ", "
    local result = ""
    for i, v in ipairs(t) do
        if i > 1 then result = result .. sep end
        result = result .. tostring(v)
    end
    return result
end

--============================================================================--
-- Système de lancer de dés
--============================================================================--

RPG.Dice = {}

-- Lancer des dés
function RPG.Dice.roll(num_dice, sides)
    num_dice = num_dice or 1
    sides = sides or 6
    
    -- Limiter le nombre de dés
    num_dice = RPG.clamp(num_dice, 1, RPG.config.max_dice_roll)
    
    local rolls = {}
    local total = 0
    
    for i = 1, num_dice do
        local roll = math.random(1, sides)
        table.insert(rolls, roll)
        total = total + roll
    end
    
    return {
        rolls = rolls,
        total = total,
        num_dice = num_dice,
        sides = sides
    }
end

-- Formater le résultat d'un lancer
function RPG.Dice.format_roll(roll_result)
    if roll_result.num_dice == 1 then
        return string.format("Rolled %d (1d%d)", roll_result.total, roll_result.sides)
    else
        local rolls_str = RPG.table_concat(roll_result.rolls, ", ")
        return string.format("Rolled %d: [%s] = Total: %d", roll_result.num_dice, rolls_str, roll_result.total)
    end
end

--============================================================================--
-- Système de personnages
--============================================================================--

RPG.Character = {}
RPG.Character.__index = RPG.Character

-- Créer un nouveau personnage
function RPG.Character:create(name, class_name, level, attributes)
    local char = {}
    setmetatable(char, RPG.Character)
    
    -- Informations de base
    char.id = RPG.generate_id()
    char.name = name:sub(1, RPG.config.max_character_name_length)
    char.class = class_name
    char.level = RPG.clamp(level or 1, 1, RPG.config.max_level)
    
    -- Obtenir la définition de la classe
    local class_def = RPG.character_class_defs[class_name]
    if not class_def then
        class_def = RPG.character_class_defs.human
    end
    
    -- Attributs
    char.attributes = RPG.table_copy(class_def.base_attributes)
    if attributes then
        for attr, value in pairs(attributes) do
            if char.attributes[attr] then
                char.attributes[attr] = RPG.clamp(value, 0, 30)
            end
        end
    end
    
    -- Sorts
    char.spells = RPG.table_copy(class_def.base_spells)
    
    -- Énergie
    char.energy = class_def.base_energy
    char.energy_max = class_def.base_energy_max
    
    -- Métadonnées
    char.created_at = os.time()
    char.updated_at = os.time()
    
    return char
end

-- Créer un personnage avec distribution de points
function RPG.Character:create_interactive()
    print("\n" .. string.rep("=", 50))
    print("CREATION DE PERSONNAGE")
    print(string.rep("=", 50))
    
    -- Étape 1: Nom
    print("\nSTEP 1/5: Character name")
    io.write("Enter name: ")
    local name = io.read("*l"):match("^%s*(.-)%s*$") or ""
    if name == "" then name = "Unknown" end
    
    -- Étape 2: Classe
    print("\nSTEP 2/5: Choose a class")
    print("Available classes:")
    for i, class_name in ipairs(RPG.config.character_classes.available) do
        local class_def = RPG.character_class_defs[class_name]
        print(string.format("  %d. %s - %s", i, class_name, class_def.description))
    end
    io.write("Class: ")
    local class_name = io.read("*l"):lower()
    
    -- Vérifier la classe
    local valid_class = false
    for _, c in ipairs(RPG.config.character_classes.available) do
        if c == class_name then
            valid_class = true
            break
        end
    end
    if not valid_class then
        class_name = "human"
        print("Invalid class. Defaulting to human.")
    end
    
    -- Étape 3: Distribution des points
    print("\nSTEP 3/5: Attribute distribution")
    print(string.format("You have %d points to distribute", RPG.config.character_classes.base_points))
    
    local class_def = RPG.character_class_defs[class_name]
    local remaining_points = RPG.config.character_classes.base_points
    local attributes = RPG.table_copy(class_def.base_attributes)
    
    local attr_names = {"intelligence", "strength", "dexterity", "endurance", "magic"}
    local attr_display = {
        intelligence = "Intelligence",
        strength = "Strength",
        dexterity = "Dexterity",
        endurance = "Endurance",
        magic = "Magic"
    }
    
    for _, attr in ipairs(attr_names) do
        local max_possible = class_def.base_attributes[attr] + remaining_points
        local min_possible = class_def.base_attributes[attr]
        
        while true do
            print(string.format("  %s (base: %d, max: %d, remaining: %d): ", 
                attr_display[attr], class_def.base_attributes[attr], max_possible, remaining_points))
            io.write("  Value: ")
            local input = io.read("*l")
            local value = tonumber(input)
            
            if value and value >= min_possible and value <= max_possible then
                attributes[attr] = value
                remaining_points = remaining_points - (value - class_def.base_attributes[attr])
                break
            else
                print(string.format("  Invalid value. Must be between %d and %d.", min_possible, max_possible))
            end
        end
    end
    
    -- Étape 4: Niveau
    print("\nSTEP 4/5: Level")
    io.write(string.format("Level (1-%d): ", RPG.config.max_level))
    local level_input = io.read("*l")
    local level = tonumber(level_input) or 1
    level = RPG.clamp(level, 1, RPG.config.max_level)
    
    -- Étape 5: Confirmation
    print("\nSTEP 5/5: Confirmation")
    print(string.format("Name: %s", name))
    print(string.format("Class: %s", class_name))
    print(string.format("Level: %d", level))
    print("Attributes:")
    for attr, value in pairs(attributes) do
        print(string.format("  %s: %d", attr_display[attr], value))
    end
    print(string.format("Remaining points: %d", remaining_points))
    
    io.write("Create this character? (y/n): ")
    local confirm = io.read("*l"):lower()
    
    if confirm == "y" or confirm == "yes" then
        return RPG.Character:create(name, class_name, level, attributes)
    else
        print("Character creation cancelled.")
        return nil
    end
end

-- Afficher les statistiques d'un personnage
function RPG.Character:display_stats()
    print(string.rep("-", 50))
    print(string.format("Character: %s", self.name))
    print(string.format("Class: %s (Level %d)", self.class, self.level))
    print(string.format("ID: %s", self.id))
    print("Attributes:")
    print(string.format("  Intelligence: %d", self.attributes.intelligence or 0))
    print(string.format("  Strength: %d", self.attributes.strength or 0))
    print(string.format("  Dexterity: %d", self.attributes.dexterity or 0))
    print(string.format("  Endurance: %d", self.attributes.endurance or 0))
    print(string.format("  Magic: %d", self.attributes.magic or 0))
    print(string.format("Energy: %d/%d", self.energy, self.energy_max))
    print(string.format("Spells: %s", RPG.table_concat(self.spells, ", ")))
    print(string.format("Created: %s", os.date("%Y-%m-%d %H:%M:%S", self.created_at)))
    print(string.rep("-", 50))
end

-- Sauvegarder un personnage en XML
function RPG.Character:save()
    local filename = string.format("%s%s.xml", RPG.config.saves_dir, self.name)
    
    -- Créer le contenu XML
    local xml_content = string.format([[
<?xml version="1.0" encoding="UTF-8"?>
<character>
    <id>%s</id>
    <name>%s</name>
    <class>%s</class>
    <level>%d</level>
    <energy>%d</energy>
    <energy_max>%d</energy_max>
    <attributes>
        <intelligence>%d</intelligence>
        <strength>%d</strength>
        <dexterity>%d</dexterity>
        <endurance>%d</endurance>
        <magic>%d</magic>
    </attributes>
    <spells>%s</spells>
    <created_at>%d</created_at>
    <updated_at>%d</updated_at>
</character>
    ]], 
        self.id,
        self.name,
        self.class,
        self.level,
        self.energy,
        self.energy_max,
        self.attributes.intelligence or 0,
        self.attributes.strength or 0,
        self.attributes.dexterity or 0,
        self.attributes.endurance or 0,
        self.attributes.magic or 0,
        RPG.table_concat(self.spells, ","),
        self.created_at,
        os.time()
    )
    
    -- Écrire le fichier
    local file = io.open(filename, "w")
    if file then
        file:write(xml_content)
        file:close()
        return true
    end
    return false
end

-- Charger un personnage depuis XML
function RPG.Character.load(name)
    local filename = string.format("%s%s.xml", RPG.config.saves_dir, name)
    
    local file = io.open(filename, "r")
    if not file then
        return nil
    end
    
    local content = file:read("*a")
    file:close()
    
    -- Parser XML simple (basique, pour ce projet)
    local char = {}
    setmetatable(char, RPG.Character)
    
    -- Extraire les valeurs avec des patterns simples
    char.id = content:match("<id>([^<]+)</id>") or RPG.generate_id()
    char.name = content:match("<name>([^<]+)</name>") or name
    char.class = content:match("<class>([^<]+)</class>") or "human"
    char.level = tonumber(content:match("<level>([^<]+)</level>")) or 1
    char.energy = tonumber(content:match("<energy>([^<]+)</energy>")) or 100
    char.energy_max = tonumber(content:match("<energy_max>([^<]+)</energy_max>")) or 100
    
    -- Charger les attributs
    char.attributes = {}
    char.attributes.intelligence = tonumber(content:match("<intelligence>([^<]+)</intelligence>")) or 5
    char.attributes.strength = tonumber(content:match("<strength>([^<]+)</strength>")) or 5
    char.attributes.dexterity = tonumber(content:match("<dexterity>([^<]+)</dexterity>")) or 5
    char.attributes.endurance = tonumber(content:match("<endurance>([^<]+)</endurance>")) or 5
    char.attributes.magic = tonumber(content:match("<magic>([^<]+)</magic>")) or 5
    
    -- Charger les sorts (séparés par des virgules)
    local spells_str = content:match("<spells>([^<]+)</spells>") or ""
    char.spells = {}
    for spell in spells_str:gmatch("[^,]+") do
        table.insert(char.spells, spell:match("^%s*(.-)%s*$"))
    end
    
    char.created_at = tonumber(content:match("<created_at>([^<]+)</created_at>")) or os.time()
    char.updated_at = tonumber(content:match("<updated_at>([^<]+)</updated_at>")) or os.time()
    
    return char
end

-- Lister tous les personnages sauvegardés
function RPG.Character.list_all()
    local lfs = require("lfs")
    local characters = {}
    
    for file in lfs.dir(RPG.config.saves_dir) do
        if file:match("%.xml$") then
            local name = file:match("^(.-)%.xml$")
            local char = RPG.Character.load(name)
            if char then
                table.insert(characters, char)
            end
        end
    end
    
    return characters
end

--============================================================================--
-- Système de monstres
--============================================================================--

RPG.Monster = {}
RPG.Monster.__index = RPG.Monster

-- Créer un nouveau monstre
function RPG.Monster:create(name, class_name, level)
    local monster = {}
    setmetatable(monster, RPG.Monster)
    
    -- Informations de base
    monster.id = RPG.generate_id()
    monster.name = name:sub(1, RPG.config.max_monster_name_length)
    monster.class = class_name
    monster.level = RPG.clamp(level or 1, 1, RPG.config.max_level)
    
    -- Obtenir la définition de la classe
    local class_def = RPG.monster_class_defs[class_name]
    if not class_def then
        class_def = RPG.monster_class_defs.werewolf
    end
    
    -- Statistiques de combat
    monster.health = class_def.base_health * (level / 10) * 1.5
    monster.health_max = monster.health
    monster.damage = class_def.base_damage * (level / 10) * 1.2
    monster.armor = class_def.base_armor * (level / 10) * 1.1
    
    -- Attributs
    monster.attributes = {}
    for attr, value in pairs(class_def.base_attributes) do
        monster.attributes[attr] = value * (level / 10) * 1.3
    end
    
    -- Sorts spéciaux
    monster.spells = RPG.table_copy(class_def.base_spells)
    
    -- Métadonnées
    monster.created_at = os.time()
    monster.updated_at = os.time()
    
    return monster
end

-- Afficher les statistiques d'un monstre
function RPG.Monster:display_stats()
    print(string.rep("-", 50))
    print(string.format("Monster: %s", self.name))
    print(string.format("Class: %s (Level %d)", self.class, self.level))
    print(string.format("ID: %s", self.id))
    print(string.format("Health: %.0f/%.0f", self.health, self.health_max))
    print(string.format("Damage: %.0f", self.damage))
    print(string.format("Armor: %.0f", self.armor))
    print("Attributes:")
    print(string.format("  Intelligence: %.0f", self.attributes.intelligence or 0))
    print(string.format("  Strength: %.0f", self.attributes.strength or 0))
    print(string.format("  Dexterity: %.0f", self.attributes.dexterity or 0))
    print(string.format("  Endurance: %.0f", self.attributes.endurance or 0))
    print(string.format("  Magic: %.0f", self.attributes.magic or 0))
    print(string.format("Special Spells: %s", RPG.table_concat(self.spells, ", ")))
    print(string.rep("-", 50))
end

-- Sauvegarder un monstre en XML
function RPG.Monster:save()
    local filename = string.format("%s%s.xml", RPG.config.monster_saves_dir, self.name)
    
    -- Créer le contenu XML
    local xml_content = string.format([[
<?xml version="1.0" encoding="UTF-8"?>
<monster>
    <id>%s</id>
    <name>%s</name>
    <class>%s</class>
    <level>%d</level>
    <health>%.0f</health>
    <health_max>%.0f</health_max>
    <damage>%.0f</damage>
    <armor>%.0f</armor>
    <attributes>
        <intelligence>%.0f</intelligence>
        <strength>%.0f</strength>
        <dexterity>%.0f</dexterity>
        <endurance>%.0f</endurance>
        <magic>%.0f</magic>
    </attributes>
    <spells>%s</spells>
    <created_at>%d</created_at>
    <updated_at>%d</updated_at>
</monster>
    ]], 
        self.id,
        self.name,
        self.class,
        self.level,
        self.health,
        self.health_max,
        self.damage,
        self.armor,
        self.attributes.intelligence or 0,
        self.attributes.strength or 0,
        self.attributes.dexterity or 0,
        self.attributes.endurance or 0,
        self.attributes.magic or 0,
        RPG.table_concat(self.spells, ","),
        self.created_at,
        os.time()
    )
    
    -- Écrire le fichier
    local file = io.open(filename, "w")
    if file then
        file:write(xml_content)
        file:close()
        return true
    end
    return false
end

-- Charger un monstre depuis XML
function RPG.Monster.load(name)
    local filename = string.format("%s%s.xml", RPG.config.monster_saves_dir, name)
    
    local file = io.open(filename, "r")
    if not file then
        return nil
    end
    
    local content = file:read("*a")
    file:close()
    
    -- Parser XML simple
    local monster = {}
    setmetatable(monster, RPG.Monster)
    
    monster.id = content:match("<id>([^<]+)</id>") or RPG.generate_id()
    monster.name = content:match("<name>([^<]+)</name>") or name
    monster.class = content:match("<class>([^<]+)</class>") or "werewolf"
    monster.level = tonumber(content:match("<level>([^<]+)</level>")) or 1
    monster.health = tonumber(content:match("<health>([^<]+)</health>")) or 60
    monster.health_max = tonumber(content:match("<health_max>([^<]+)</health_max>")) or 60
    monster.damage = tonumber(content:match("<damage>([^<]+)</damage>")) or 12
    monster.armor = tonumber(content:match("<armor>([^<]+)</armor>")) or 8
    
    -- Charger les attributs
    monster.attributes = {}
    monster.attributes.intelligence = tonumber(content:match("<intelligence>([^<]+)</intelligence>")) or 6
    monster.attributes.strength = tonumber(content:match("<strength>([^<]+)</strength>")) or 8
    monster.attributes.dexterity = tonumber(content:match("<dexterity>([^<]+)</dexterity>")) or 7
    monster.attributes.endurance = tonumber(content:match("<endurance>([^<]+)</endurance>")) or 7
    monster.attributes.magic = tonumber(content:match("<magic>([^<]+)</magic>")) or 2
    
    -- Charger les sorts
    local spells_str = content:match("<spells>([^<]+)</spells>") or ""
    monster.spells = {}
    for spell in spells_str:gmatch("[^,]+") do
        table.insert(monster.spells, spell:match("^%s*(.-)%s*$"))
    end
    
    monster.created_at = tonumber(content:match("<created_at>([^<]+)</created_at>")) or os.time()
    monster.updated_at = tonumber(content:match("<updated_at>([^<]+)</updated_at>")) or os.time()
    
    return monster
end

-- Lister tous les monstres sauvegardés
function RPG.Monster.list_all()
    local lfs = require("lfs")
    local monsters = {}
    
    for file in lfs.dir(RPG.config.monster_saves_dir) do
        if file:match("%.xml$") then
            local name = file:match("^(.-)%.xml$")
            local monster = RPG.Monster.load(name)
            if monster then
                table.insert(monsters, monster)
            end
        end
    end
    
    return monsters
end

--============================================================================--
-- Système de commandes
--============================================================================--

RPG.Commands = {}

-- Tableau des commandes disponibles
RPG.Commands.help_text = {
    ["!createplayer"] = "Start interactive character creation",
    ["!listplayer"] = "List all saved characters",
    ["!getplayer <name>"] = "Load and display a specific character",
    ["!stats"] = "Show current character's statistics",
    ["!createmonster <name> <class> <level>"] = "Create a new monster",
    ["!listmonsters"] = "List all saved monsters",
    ["!getmonster <name>"] = "Load and display a specific monster",
    ["!roll <number>"] = "Roll dice (default: 1d6, max 10 dice)",
    ["!hello"] = "Friendly greeting",
    ["!ping"] = "Test connection",
    ["!help"] = "Show this help message",
    ["!quit"] = "Quit the program"
}

-- Character actuel chargé
RPG.current_character = nil
RPG.current_monster = nil

-- Traiter une commande
function RPG.Commands.handle(command, args)
    -- Nettoyer la commande (enlever les espaces superflus)
    command = command:lower():match("^%s*(.-)%s*$") or command
    
    -- Parser les arguments
    local command_args = {}
    for arg in (args or ""):gmatch("%S+") do
        table.insert(command_args, arg)
    end
    
    -- Exécuter la commande
    if command == "!createplayer" or command == "createplayer" then
        RPG.current_character = RPG.Character:create_interactive()
        if RPG.current_character then
            RPG.current_character:save()
            print("Character created and saved!")
            RPG.current_character:display_stats()
        end
        
    elseif command == "!listplayer" or command == "listplayer" then
        print(string.rep("=", 50))
        print("SAVED CHARACTERS")
        print(string.rep("=", 50))
        local characters = RPG.Character.list_all()
        if #characters == 0 then
            print("No characters found.")
        else
            print(string.format("Found %d character(s):", #characters))
            for i, char in ipairs(characters) do
                print(string.format("  %d. %s (%s, Level %d)", i, char.name, char.class, char.level))
            end
        end
        
    elseif command == "!getplayer" or command == "getplayer" then
        if #command_args > 0 then
            RPG.current_character = RPG.Character.load(command_args[1])
            if RPG.current_character then
                print("Character loaded!")
                RPG.current_character:display_stats()
            else
                print(string.format("Character '%s' not found.", command_args[1]))
            end
        else
            print("Usage: !getplayer <name>")
        end
        
    elseif command == "!stats" or command == "stats" then
        if RPG.current_character then
            RPG.current_character:display_stats()
        else
            print("No character loaded. Use !getplayer <name> or !createplayer first.")
        end
        
    elseif command == "!createmonster" or command == "createmonster" then
        if #command_args >= 3 then
            local name = command_args[1]
            local class_name = command_args[2]:lower()
            local level = tonumber(command_args[3]) or 1
            
            RPG.current_monster = RPG.Monster:create(name, class_name, level)
            if RPG.current_monster then
                RPG.current_monster:save()
                print("Monster created and saved!")
                RPG.current_monster:display_stats()
            end
        else
            print("Usage: !createmonster <name> <class> <level>")
            print("Available monster classes:")
            for i, class_name in ipairs(RPG.config.monster_classes.available) do
                print(string.format("  - %s", class_name))
            end
        end
        
    elseif command == "!listmonsters" or command == "listmonsters" then
        print(string.rep("=", 50))
        print("SAVED MONSTERS")
        print(string.rep("=", 50))
        local monsters = RPG.Monster.list_all()
        if #monsters == 0 then
            print("No monsters found.")
        else
            print(string.format("Found %d monster(s):", #monsters))
            for i, monster in ipairs(monsters) do
                print(string.format("  %d. %s (%s, Level %d)", i, monster.name, monster.class, monster.level))
            end
        end
        
    elseif command == "!getmonster" or command == "getmonster" then
        if #command_args > 0 then
            RPG.current_monster = RPG.Monster.load(command_args[1])
            if RPG.current_monster then
                print("Monster loaded!")
                RPG.current_monster:display_stats()
            else
                print(string.format("Monster '%s' not found.", command_args[1]))
            end
        else
            print("Usage: !getmonster <name>")
        end
        
    elseif command == "!roll" or command == "roll" then
        local num_dice = tonumber(command_args[1]) or 1
        local roll_result = RPG.Dice.roll(num_dice)
        print(RPG.Dice.format_roll(roll_result))
        
    elseif command == "!hello" or command == "hello" then
        print("Hello! Welcome to " .. RPG.name .. " v" .. RPG.version .. "!")
        
    elseif command == "!ping" or command == "ping" then
        print("Pong! Bot is responsive.")
        
    elseif command == "!help" or command == "help" then
        print(string.rep("=", 50))
        print(RPG.name .. " - Available Commands")
        print(string.rep("=", 50))
        print("\nCharacter Commands:")
        for cmd, desc in pairs(RPG.Commands.help_text) do
            if cmd:find("player") or cmd:find("stats") or cmd:find("hello") or cmd:find("ping") then
                print(string.format("  %s - %s", cmd, desc))
            end
        end
        print("\nMonster Commands:")
        for cmd, desc in pairs(RPG.Commands.help_text) do
            if cmd:find("monster") then
                print(string.format("  %s - %s", cmd, desc))
            end
        end
        print("\nUtility Commands:")
        for cmd, desc in pairs(RPG.Commands.help_text) do
            if cmd:find("roll") or cmd:find("help") or cmd:find("quit") then
                print(string.format("  %s - %s", cmd, desc))
            end
        end
        print(string.rep("=", 50))
        
    elseif command == "!quit" or command == "quit" then
        print("Goodbye! Thanks for playing " .. RPG.name .. ".")
        return false  -- Signal pour quitter
        
    else
        print(string.format("Unknown command: %s. Type !help for available commands.", command))
    end
    
    return true  -- Continuer
end

--============================================================================--
-- Interface de ligne de commande
--============================================================================--

-- Mode interactif
function RPG.run_interactive()
    print(string.rep("=", 50))
    print(RPG.name .. " v" .. RPG.version)
    print("A Lua-based RPG command prompt")
    print("Type !help for available commands, !quit to exit")
    print(string.rep("=", 50))
    
    -- Initialiser les répertoires
    RPG.ensure_saves_directories()
    
    -- Boucle principale
    while true do
        io.write("\n> ")
        local input = io.read("*l")
        
        if input and input ~= "" then
            -- Trouver la commande (premier mot)
            local command, args = input:match("^(%S+)%s*(.*)$")
            
            if command then
                command = command:lower()
                -- Ajouter ! si ce n'est pas déjà fait
                if not command:find("^!") then
                    command = "!" .. command
                end
                
                local should_continue = RPG.Commands.handle(command, args)
                if not should_continue then
                    break
                end
            end
        end
    end
end

-- Mode script (exécuter une commande et quitter)
function RPG.run_command(command)
    RPG.ensure_saves_directories()
    
    -- Parser la commande et les arguments
    -- Capturer le premier mot et le reste
    local cmd, cmd_args = command:match("^(%S+)%s*(.*)$")
    
    -- Ajouter ! si ce n'est pas déjà fait
    if not cmd:find("^!") then
        cmd = "!" .. cmd
    end
    
    RPG.Commands.handle(cmd, cmd_args)
end

--============================================================================--
-- Point d'entrée principal
--============================================================================--

-- Vérifier si un argument de ligne de commande est fourni
if #arg > 0 then
    -- Mode script: exécuter la commande et quitter
    local command = table.concat(arg, " ")
    RPG.run_command(command)
else
    -- Mode interactif
    RPG.run_interactive()
end

-- Retourner le module RPG pour une utilisation programmatique
