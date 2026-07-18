#!/bin/bash
# tools/rpg-prompt.sh - Wrapper pour le script RPG Command Prompt en Lua
# Permet d'exécuter facilement le RPG Lua depuis RefPerSys

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RPG_DIR="${SCRIPT_DIR}/../plugins/rpg-irc-bot"

# Vérifier que le script Lua existe
if [ ! -f "${RPG_DIR}/command_prompt.lua" ]; then
    echo "ERREUR: Le script RPG n'est pas trouvé dans ${RPG_DIR}/"
    echo ""
    echo "Pour l'installer:"
    echo "  1. mkdir -p plugins/rpg-irc-bot"
    echo "  2. git clone https://github.com/jack-sparrow-code/rpg-irc-bot.git plugins/rpg-irc-bot"
    echo "  3. Le script command_prompt.lua devrait être dans plugins/rpg-irc-bot/"
    exit 1
fi

# Vérifier que Lua est installé
if ! command -v lua &> /dev/null && ! command -v lua5.4 &> /dev/null && ! command -v lua5.3 &> /dev/null; then
    echo "ERREUR: Lua n'est pas installé."
    echo "Installez Lua avec: sudo apt install lua5.4"
    exit 1
fi

# Trouver la commande Lua
LUA_CMD=""
for cmd in lua lua5.4 lua5.3 lua5.2 lua5.1; do
    if command -v $cmd &> /dev/null; then
        LUA_CMD=$cmd
        break
    fi
done

if [ -z "$LUA_CMD" ]; then
    echo "ERREUR: Impossible de trouver Lua."
    exit 1
fi

# Changer vers le répertoire RPG et exécuter
cd "${RPG_DIR}" || exit 1

# Vérifier et installer LuaFileSystem si nécessaire
if [ ! -d "${RPG_DIR}/.luarocks" ] && ! $LUA_CMD -e "require('lfs')" &> /dev/null; then
    echo "[INFO] Installation de LuaFileSystem..."
    if command -v luarocks &> /dev/null; then
        luarocks install luafilesystem
    elif $LUA_CMD -e "require('lfs')" &> /dev/null; then
        echo "[OK] LuaFileSystem déjà installé"
    else
        echo "[WARN] LuaFileSystem non disponible. Certains fonctionnalités peuvent être limitées."
        echo "Installez avec: sudo apt install lua-lfs"
    fi
fi

# Exécuter le script Lua avec les arguments
$LUA_CMD command_prompt.lua "$@"

exit $?
