# Gemini CLI Helper

This directory contains a set of scripts to run Google's Gemini models via a Docker container, allowing you to use Gemini directly from your command line in any directory.

## File Descriptions

*   **`installGeminiHelper.sh`**:
    *   **Purpose**: Installing the Gemini CLI helper.
    *   **Function**:
        *   **Validation**: Verifies that `.env` exists and contains a `GEMINI_API_KEY`.
        *   **Build**: Builds the Docker image named `gemini-local-helper`.
        *   **Setup**: Creates a symbolic link for `runGeminiComandLine.sh` in `~/.local/bin/runGeminiComandLine`, making it globally accessible.
        *   **Auto-Configuration**: Checks if `~/.local/bin` is in your `$PATH`. If not, it attempts to automatically add it to your `~/.bashrc` or `~/.zshrc`.

*   **`runGeminiComandLine.sh`**:
    *   **Purpose**: The main script to run Gemini.
    *   **Function**:
        *   Wraps the Docker execution command.
        *   Mounts the current working directory to `/workdir` inside the container.
        *   Passes the `GEMINI_API_KEY` from the `.env` file to the container.
        *   Allows you to select which Gemini model to use (e.g., experimental, flash, pro).

*   **`dockerfile`**:
    *   **Purpose**: Defines the environment for the Gemini CLI.
    *   **Function**: Contains the instructions to build the `gemini-local-helper` image with necessary dependencies.

*   **`.env`**:
    *   **Purpose**: Configuration file.
    *   **Function**: Stores your sensitive `GEMINI_API_KEY`. **You must create this file.**

*   **`.env.example`**:
    *   **Purpose**: Template for the `.env` file.

## Installation

1.  **Configure Environment**:
    Rename `.env.example` to `.env` and add your API key:
    ```bash
    cp .env.example .env
    # Edit .env and paste your GEMINI_API_KEY
    ```

2.  **Run Installer**:
    This script will build the Docker image and setup the global command.
    ```bash
    ./installGeminiHelper.sh
    ```
    
    *   **Note on PATH**: If `~/.local/bin` is not in your system PATH, the script will warn you and attempt to add it to your shell configuration (`~/.bashrc` or `~/.zshrc`).
    *   **Immediate Usage**: If the PATH was just added, you may need to run `source ~/.profile` (or `source ~/.bashrc`) or restart your terminal to use the command immediately.

## Usage

Once installed, you can run `runGeminiComandLine` from any directory.

```bash
runGeminiComandLine
```

The script will prompt you to select a model. The current directory will be mounted, so the tool can access files in the folder where you run the command.
