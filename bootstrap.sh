#!/usr/bin/env bash
set -e #exit on errors


# ------------------------------------
#  Create script variables
# ------------------------------------
REPO_BASE="https://raw.githubusercontent.com/khbtechservices/linux-bootstrap/main"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'
INFO='\033[0;30;106m'
SUCCESS='\033[0;30;42m'
BOLD_DEFAULT='\033[1m'
RESET='\033[0m'

# --------------------------------------
# Set up temporary folder for downloads
# --------------------------------------
printf "\n${INFO} SETUP ${RESET} Creating temporary folder for downloads...\n"
TMP_DIR=$(mktemp -d)
printf "\n${INFO} SETUP ${RESET} Setting up automatic cleanup actions...\n"
cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT #call cleanup on exit

# -------------------------------
#  Install git
# -------------------------------
printf "\n${INFO} GIT ${RESET} Installing git...\n"
sudo apt install -y git


# -------------------------------
# 1. Append custom .bashrc lines
#--------------------------------
printf "\n${INFO} BASH ${RESET} Customize .bashrc\n"
BASHRC="$HOME/.bashrc"
CUSTOM_BASHRC="custom_bashrc"
CUSTOM_BASHRC_MARKER="#== KHB3 LINUX BOOTSTRAP ==#"

# Backup original if not present
if [ ! -f "${BASHRC}.orig" ]; then
    printf "\n${INFO} BASH ${RESET} Backing up ${BASHRC} to ${BASHRC}.orig...\n"  
    cp "$BASHRC" "${BASHRC}.orig"
fi

# Only append if not present
if ! grep -q "$CUSTOM_BASHRC_MARKER" "$BASHRC"; then
    printf "\n${INFO} BASH ${RESET} Downloading custom snippet...\n"  
    curl -fsSL "$REPO_BASE/$CUSTOM_BASHRC" -o "$TMP_DIR/$CUSTOM_BASHRC"
    printf "\n${INFO} BASH ${RESET} Writing custom snippet to ${BASHRC}...\n"  
    echo "" >> "$BASHRC"
    echo "$CUSTOM_BASHRC_MARKER" >> "$BASHRC"
    cat "$TMP_DIR/$CUSTOM_BASHRC" >> "$BASHRC"
    echo "" >> "$BASHRC"
fi


# -------------------------------
# 2. Install vim-plug
#--------------------------------
printf "\n${INFO} VIM ${RESET} Customize VIM\n"  

if ! command -v vim >/dev/null 2>&1; then
    printf "\n${INFO} VIM ${RESET} Vim not found.  Installing...\n"  
    sudo apt update
    sudo apt install -y vim
fi

printf "\n${INFO} VIM ${RESET} Vim installed. Customizing...\n"  
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    printf "\n${INFO} VIM ${RESET} Installing vim-plug...\n"  
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi


# -------------------------------
# 3. Update/Install ~/.vimrc
#--------------------------------

VIMRC="$HOME/.vimrc"
CUSTOM_VIMRC="custom_vimrc"
CUSTOM_VIMRC_MARKER="\" KHB LINUX BOOTSTRAP"

if [ ! -f "$VIMRC" ]; then
    printf "\n${INFO} VIM ${RESET} Creating initial ${VIMRC}...\n"  
    touch "$VIMRC"
fi

if ! grep -q "$CUSTOM_VIMRC_MARKER" "$VIMRC"; then
    printf "\n${INFO} VIM ${RESET} Downloading custom .vimrc snippet...\n"  
    curl -fsSL "$REPO_BASE/$CUSTOM_VIMRC" -o "$TMP_DIR/$CUSTOM_VIMRC"
    printf "\n${INFO} VIM ${RESET} Writing custom .vimrc snippet...\n"  
    echo "" >> "$VIMRC"
    echo "$CUSTOM_VIMRC_MARKER" >> "$VIMRC"
    cat "$TMP_DIR/$CUSTOM_VIMRC" >> "$VIMRC"
    echo "" >> "$VIMRC"
fi


# -------------------------------
# 4. Perform PlugInstall
#--------------------------------
printf "\n${INFO} VIM ${RESET} Running PlugInstall...\n"  
vim +PlugInstall +qall


# -------------------------------
# 5. Closing remarks/instructions
#--------------------------------
printf "\n"
printf "\n${SUCCESS} DONE ${RESET} Bootstraping complete!\n"
printf "\n${GREEN}Run: ${CYAN}source ~/.bashrc ${GREEN}to apply prompt updates.${RESET}\n"