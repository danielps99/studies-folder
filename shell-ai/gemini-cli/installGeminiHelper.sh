#!/bin/bash

# Exit on error
set -e

# Configuration
BIN_DIR="$HOME/.local/bin"

log_info() {
    echo -e "\033[0;32m[INFO]\033[0m $1"
}

log_warn() {
    echo -e "\033[0;33m[WARN]\033[0m $1"
}

log_error() {
    echo -e "\033[0;31m[ERROR]\033[0m $1"
}

check_env() {
    log_info "Verifying environment configuration..."
    if [ ! -f .env ]; then
        log_error ".env file not found in the current directory."
        echo "Please rename .env.example to .env before running this installation script."
        exit 1
    fi

    if ! grep -q "^GEMINI_API_KEY=" .env; then
        log_error "GEMINI_API_KEY is not defined in .env file."
        echo "Please add GEMINI_API_KEY=your_api_key to the .env file. See the example in .env.example"
        exit 1
    fi
}

build_docker_image() {
    log_info "Building Docker image 'gemini-local-helper'..."
    docker build -t gemini-local-helper .
}

setup_script() {
    local script_name="$1"
    local link_name="$2"
    local full_path="$(pwd)/$script_name"

    if [ ! -f "$script_name" ]; then
        log_error "$script_name not found."
        exit 1
    fi

    log_info "Making $script_name executable..."
    chmod +x "$script_name"

    log_info "Creating symbolic link for $link_name in $BIN_DIR..."
    mkdir -p "$BIN_DIR"

    # Remove existing link or file
    if [ -L "$BIN_DIR/$link_name" ] || [ -f "$BIN_DIR/$link_name" ]; then
        rm "$BIN_DIR/$link_name"
    fi

    ln -s "$full_path" "$BIN_DIR/$link_name"
    log_info "Link created: $BIN_DIR/$link_name -> $full_path"
}

update_path() {
    # Check if BIN_DIR is in PATH
    if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
        log_warn "$BIN_DIR is not in your PATH."
        
        local shell_rc=""
        local profile_rc="$HOME/.profile"
        
        # Check .profile first
        if [ -f "$profile_rc" ] && grep -q "$BIN_DIR" "$profile_rc"; then
            log_info "PATH configuration found in $profile_rc. It will be applied on next login."
            return
        fi

        # Determine shell rc file
        if [ -f "$HOME/.bashrc" ]; then
            shell_rc="$HOME/.bashrc"
        elif [ -f "$HOME/.zshrc" ]; then
            shell_rc="$HOME/.zshrc"
        fi

        if [ -n "$shell_rc" ]; then
            if ! grep -q "$BIN_DIR" "$shell_rc"; then
                log_info "Adding export to $shell_rc..."
                {
                    echo ""
                    echo "# Added by gemini-cli installer"
                    echo "export PATH=\"\$HOME/.local/bin:\$PATH\""
                } >> "$shell_rc"
                log_info "Successfully added to $shell_rc"
            else
                log_info "PATH configuration already found in $shell_rc"
            fi
        fi

        echo ""
        log_warn "To use the command in THIS terminal, please run:"
        echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
        echo "Future terminals will have it automatically."
    else
        log_info "$BIN_DIR is already in your PATH."
    fi
}

main() {
    log_info "Starting installation..."
    
    check_env
    build_docker_image
    
    setup_script "runGeminiComandLine.sh" "runGeminiComandLine"
    setup_script "gitCommit.sh" "gitCommit"
    
    update_path
    
    log_info "Installation complete."
}

main
