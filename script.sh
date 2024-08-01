#!/bin/bash

# Définition des chemins
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REPO_DIR="$SCRIPT_DIR/WorldGuard"
REPO_DIR_PATCH="$SCRIPT_DIR/WorldGuard-Patchs"
REPO_URL="https://github.com/EngineHub/WorldGuard"
PATCHES_DIR="$SCRIPT_DIR/patches/plugins"
BRANCH_GIT="version/7.0.x"

# S'assurer que le répertoire des patches existe
mkdir -p "$PATCHES_DIR"

# Fonction pour recloner le dépôt
reclone_repo() {
    echo "Suppression des dépôts locaux..."
    rm -rf "$REPO_DIR"
    rm -rf "$REPO_DIR_PATCH"
    echo "Clonage du dépôt..."
    git clone "$REPO_URL" "$REPO_DIR" -b "$BRANCH_GIT"
    echo "Le dépôt a été recloné."
    echo "Début de la copie du code"
    cp -r "$REPO_DIR" "$REPO_DIR_PATCH"
    echo "Les patches peuvent être appliqués"
}

# Fonction pour créer des patches
create_patches() {
    cd "$REPO_DIR_PATCH" || exit
    echo "Création des patches..."
    git format-patch -o "$PATCHES_DIR" origin/$BRANCH_GIT
    echo "Les patches ont été créés dans $REPO_DIR_PATCH"
}

# Fonction pour appliquer des patches
apply_patches() {
    cd "$REPO_DIR_PATCH" || exit
    echo "Application des patches..."
    for patch in "$PATCHES_DIR"/*.patch; do
        git apply "$patch"
        patch_name=$(basename "$patch" .patch)
        patch_description=$(echo "$patch_name" | sed 's/^[0-9]*-//')
        patch_description=$(echo "$patch_description" | sed 's/-/ /g')
        git add .
        git commit -m "$patch_description"
        echo "Patch \"$patch_description\" appliqué."
    done
}

# Vérification des arguments pour choisir l'action
case "$1" in
    updateUpstream)
        reclone_repo
        ;;
    createPatches)
        create_patches
        ;;
    applyPatches)
        apply_patches
        ;;
    *)
        echo "Utilisation possible du script:
            $0 updateUpstream
                Permet de mettre à jour le code source en supprimant et en reclonant le dossier source
            $0 createPatches
                Permet de créer les patches
            $0 applyPatches
                Permet d'appliquer les patches"
        exit 1
        ;;
esac