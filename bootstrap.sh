#!/usr/bin/env bash
set -e #exit on errors


# ------------------------------------
#  Create script variables
# ------------------------------------
REPO_RAW_BASE="https://raw.githubusercontent.com/khbtechservices/linux-bootstrap/main"
CUSTOM_MARKER="#== KHB3 LINUX BOOTSTRAP ==#"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --------------------------------------
# Set up temporary folder for downloads
# --------------------------------------
echo "Creating temporary folder for downloads..."
TMP_DIR=$(mktemp -d)
echo "Setting up automatic cleanup actions..."
cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT #call cleanup on exit

# -------------------------------
# 1. Append custom .bashrc lines
#--------------------------------
BASHRC="$HOME/.bashrc"
CUSTOM_BASHRC="$REPO_DIR/custom_bashrc"

# Only append if not present
if ! grep -q "$CUSTOM_MARKER" "$BASHRC"; then
    echo "Downloading custom .bashrc snippet..."
    curl -fsSL "$REPO_RAW_BASE/$CUSTOM_BASHRC" -o "$TMP_DIR/$CUSTOM_BASHRC"
    echo "Writing custom .bashrc snippet to ${BASHRC}..."
    echo "" >> "$BASHRC"
    echo "$CUSTOM_MARKER" >> "$BASHRC"
    cat "$TMP_DIR/$CUSTOM_BASHRC" >> "$BASHRC"
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
    echo "Downloading custom .vimrc snippet..."
    curl -fsSL "$REPO_RAW_BASE/$CUSTOM_VIMRC" -o "$TMP_DIR/$CUSTOM_VIMRC"
    echo "Writing custom .vimrc lines to ${VIMRC}..."
    echo "" >> "$VIMRC"
    echo "$CUSTOM_MARKER" >> "$VIMRC"
    cat "$TMP_DIR/$CUSTOM_VIMRC" >> "$VIMRC"
    echo "" >> "$VIMRC"
fi


# -------------------------------
# 4. Perform PlugInstall
#--------------------------------

echo "Running PlugInstall..."
vim +PlugInstall +qall
