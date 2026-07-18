#!/bin/bash
# tools/db-explore.sh - Wrapper pour le plugin db-explore
# Permet d'appeler les fonctionnalités MySQL depuis RefPerSys
# Adapté pour blues-softwares

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="${SCRIPT_DIR}/../plugins/db-explore"
PROJECT_DIR="${SCRIPT_DIR}/.."

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
msg_error() {
    echo -e "${RED}[ERREUR]${NC} $1" >&2
}
msg_ok() {
    echo -e "${GREEN}[OK]${NC} $1"
}
msg_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

# Vérifier que le plugin existe
if [ ! -d "$PLUGIN_DIR" ]; then
    msg_error "Le plugin db-explore n'est pas installé dans ${PLUGIN_DIR}"
    echo "Pour l'installer:"
    echo "  mkdir -p ${PROJECT_DIR}/plugins"
    echo "  git clone https://github.com/jack-sparrow-code/db-explore.git ${PROJECT_DIR}/plugins/db-explore"
    exit 1
fi

# Vérifier que python3 est disponible
if ! command -v python3 &> /dev/null; then
    msg_error "python3 n'est pas installé"
    exit 1
fi

# Vérifier que mysql.connector est disponible
if ! python3 -c "import mysql.connector" 2> /dev/null; then
    msg_error "mysql-connector-python n'est pas installé"
    msg_info "Installation: sudo apt install -y python3-mysql.connector"
    msg_info "            OU: pip install --break-system-packages mysql-connector-python"
    exit 1
fi

# Changer vers le répertoire du plugin
cd "$PLUGIN_DIR" || exit 1

# Exécuter la commande demandée
case "$1" in
    create)
        msg_info "Création de la base de données..."
        python3 create_database.py
        ;;
    insert)
        if [ -z "$2" ] || [ -z "$3" ]; then
            msg_error "Usage: $0 insert <nom> <age>"
            exit 1
        fi
        msg_info "Insertion de l'utilisateur '$2' (âge: $3)..."
        python3 insert_data.py "$2" "$3"
        ;;
    update)
        if [ -z "$2" ] || [ -z "$3" ]; then
            msg_error "Usage: $0 update <nom> <nouvel_age>"
            exit 1
        fi
        msg_info "Mise à jour de l'utilisateur '$2' (nouvel âge: $3)..."
        python3 update_data.py "$2" "$3"
        ;;
    query|list)
        msg_info "Liste des utilisateurs..."
        python3 query_data.py
        ;;
    delete)
        if [ -z "$2" ]; then
            msg_error "Usage: $0 delete <nom>"
            exit 1
        fi
        msg_info "Suppression de l'utilisateur '$2'..."
        python3 -c "
import mysql.connector
from config import DB_CONFIG
try:
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    cursor.execute(\"DELETE FROM utilisateurs WHERE nom = %s\", ('$2',))
    conn.commit()
    print(f'Utilisateur \"$2\" supprimé avec succès')
    cursor.close()
    conn.close()
except Exception as e:
    print(f'Erreur: {e}')
"
        ;;
    menu)
        msg_info "Lancement du menu interactif..."
        python3 main.py
        ;;
    ssh-create)
        msg_info "Création de la base via SSH sur blues-softwares..."
        ssh jean-christophe@blues-softwares "cd ${PLUGIN_DIR} && python3 create_database.py"
        ;;
    ssh-insert)
        if [ -z "$2" ] || [ -z "$3" ]; then
            msg_error "Usage: $0 ssh-insert <nom> <age>"
            exit 1
        fi
        msg_info "Insertion via SSH de l'utilisateur '$2' (âge: $3)..."
        ssh jean-christophe@blues-softwares "cd ${PLUGIN_DIR} && python3 insert_data.py \"$2\" \"$3\""
        ;;
    ssh-query)
        msg_info "Liste des utilisateurs via SSH..."
        ssh jean-christophe@blues-softwares "cd ${PLUGIN_DIR} && python3 query_data.py"
        ;;
    setup)
        msg_info "Initialisation complète de la base..."
        python3 create_database.py
        python3 insert_data.py "Admin" 99
        msg_ok "Base initialisée avec un utilisateur Admin"
        ;;
    backup)
        BACKUP_FILE="/home/jean-christophe/backups/refpersys_db_$(date +%Y%m%d_%H%M%S).sql"
        msg_info "Sauvegarde de la base en cours: $BACKUP_FILE"
        mkdir -p /home/jean-christophe/backups
        mysqldump -u jean-christophe -pCoding2029 refpersys_db > "$BACKUP_FILE" 2>&1
        if [ $? -eq 0 ]; then
            msg_ok "Sauvegarde terminée: $BACKUP_FILE"
        else
            msg_error "Échec de la sauvegarde"
            exit 1
        fi
        ;;
    restore)
        if [ -z "$2" ]; then
            msg_error "Usage: $0 restore <fichier.sql>"
            exit 1
        fi
        if [ ! -f "$2" ]; then
            msg_error "Fichier $2 introuvable"
            exit 1
        fi
        msg_info "Restauration depuis $2..."
        mysql -u jean-christophe -pCoding2029 -e "DROP DATABASE IF EXISTS refpersys_db; CREATE DATABASE refpersys_db;" 2>/dev/null
        mysql -u jean-christophe -pCoding2029 refpersys_db < "$2" 2>&1
        if [ $? -eq 0 ]; then
            msg_ok "Restauration terminée"
        else
            msg_error "Échec de la restauration"
            exit 1
        fi
        ;;
    help|--help|-h)
        echo "Usage: $0 {commande} [arguments]"
        echo ""
        echo "Commandes disponibles:"
        echo "  create              # Créer la base de données et la table"
        echo "  insert <nom> <age>  # Insérer un utilisateur"
        echo "  update <nom> <age>  # Mettre à jour un utilisateur"
        echo "  query|list          # Lister les utilisateurs"
        echo "  delete <nom>        # Supprimer un utilisateur"
        echo "  menu                # Menu interactif"
        echo ""
        echo "  ssh-create          # Créer la base via SSH (blues-softwares)"
        echo "  ssh-insert <n> <a>  # Insérer via SSH"
        echo "  ssh-query           # Lister via SSH"
        echo ""
        echo "  setup               # Initialisation complète"
        echo "  backup              # Sauvegarder la base"
        echo "  restore <file.sql>  # Restaurer la base"
        echo ""
        echo "  help                # Affiche cette aide"
        echo ""
        echo "Exemples:"
        echo "  $0 create"
        echo "  $0 insert \"Jean\" 45"
        echo "  $0 update \"Jean\" 46"
        echo "  $0 query"
        ;;
    *)
        msg_error "Commande inconnue: $1"
        echo ""
        echo "Utilisez $0 help pour voir l'aide"
        exit 1
        ;;
esac

exit 0
