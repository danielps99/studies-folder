#!/bin/bash

# Exit on error
set -e

echo "Starting installation..."

# Verify .env file exists
if [ ! -f .env ]; then
    echo "Error: .env file not found in the current directory."
    echo "Please rename .env.example to .env before running this installation script."
    exit 1
fi

# Verify GEMINI_API_KEY is defined in .env
if ! grep -q "^GEMINI_API_KEY=" .env; then
    echo "Error: GEMINI_API_KEY is not defined in .env file."
    echo "Please add GEMINI_API_KEY=your_api_key to the .env file. See the example in .env.example"
    exit 1
fi

# Build docker image
echo "Building Docker image 'gemini-local-helper'..."
docker build -t gemini-local-helper .

# Setup the command line script
SCRIPT_NAME="runGeminiComandLine.sh"
if [ ! -f "$SCRIPT_NAME" ]; then
    echo "Error: $SCRIPT_NAME not found."
    exit 1
fi

echo "Making $SCRIPT_NAME executable..."
chmod +x "$SCRIPT_NAME"

# Create symbolic link
BIN_DIR="$HOME/.local/bin"
LINK_NAME="runGeminiComandLine"
FULL_PATH="$(pwd)/$SCRIPT_NAME"

echo "Creating symbolic link in $BIN_DIR..."
mkdir -p "$BIN_DIR"

# Check if link exists and remove it
if [ -L "$BIN_DIR/$LINK_NAME" ] || [ -f "$BIN_DIR/$LINK_NAME" ]; then
    rm "$BIN_DIR/$LINK_NAME"
fi

ln -s "$FULL_PATH" "$BIN_DIR/$LINK_NAME"

echo "Link created: $BIN_DIR/$LINK_NAME -> $FULL_PATH"
echo "Installation complete."

# Check if BIN_DIR is in PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo "WARNING: $BIN_DIR is not in your PATH."
    
    # Try to add to .bashrc or .zshrc
    SHELL_RC=""
    PROFILE_RC="$HOME/.profile"
    
    # Check if configured in .profile first (common in Ubuntu)
    if [ -f "$PROFILE_RC" ] && grep -q "$BIN_DIR" "$PROFILE_RC"; then
        echo "PATH configuration found in $PROFILE_RC."
        echo "It will be automatically applied on next login."
    else
        # Not found in .profile, check shell specific rc
        if [ -f "$HOME/.bashrc" ]; then
            SHELL_RC="$HOME/.bashrc"
        elif [ -f "$HOME/.zshrc" ]; then
            SHELL_RC="$HOME/.zshrc"
        fi
    fi

    if [ -n "$SHELL_RC" ]; then
        if ! grep -q "$BIN_DIR" "$SHELL_RC"; then
            echo "Adding export to $SHELL_RC..."
            echo "" >> "$SHELL_RC"
            echo "# Added by gemini-cli installer" >> "$SHELL_RC"
            echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$SHELL_RC"
            echo "Successfully added to $SHELL_RC"
        else
            echo "PATH configuration already found in $SHELL_RC"
        fi
    fi

    echo "To use the command in THIS terminal, please run:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo "Future terminals will have it automatically."
fi
