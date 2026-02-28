#!/usr/bin/env bash
set -e #exit on errors

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# -------------------------------
# 1. Append custom .bashrc lines
#--------------------------------
BASHRC="$HOME/.bashrc"
CUSTOM_BASHRC="$REPO_DIR/custom_bashrc"
CUSTOM_MARKER="#== KHB3 LINUX BOOTSTRAP ==#"

# Only append if not present
if ! grep -q "$CUSTOM_MARKER" "$BASHRC"; then
    echo "Writing custom .bashrc lines to ${BASHRC}..."
    echo "" >> "$BASHRC"
    echo "$CUSTOM_MARKER" >> "$BASHRC"
    cat "$CUSTOM_BASHRC" >> "$BASHRC"
    echo "" >> "$BASHRC"

    # Source the file
    source "$BASHRC"
    echo "Sourced $BASHRC"
fi


# -------------------------------
# 2. Install vim-plug
#--------------------------------

if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    echo "Istalling vim-plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi


# -------------------------------
# 3. Update/Install ~/.vimrc
#--------------------------------

VIMRC="$HOME/.vimrc"
CUSTOM_VIMRC="$REPO_DIR/custom_vimrc"

if [ ! -f "$VIMRC" ]; then
    echo "Creating initial ${VIMRC}..."
    touch "$VIMRC"
fi

if ! grep -q "$CUSTOM_MARKER" "$VIMRC"; then
    echo "Writing custom .vimrc lines to ${VIMRC}..."
    echo "" >> "$VIMRC"
    echo "$CUSTOM_MARKER" >> "$VIMRC"
    cat "$CUSTOM_VIMRC" >> "$VIMRC"
    echo "" >> "$VIMRC"
fi


# -------------------------------
# 4. Perform PlugInstall
#--------------------------------

echo "Running PlugInstall..."
vim +PlugInstall +qall
