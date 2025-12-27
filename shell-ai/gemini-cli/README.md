# Gemini CLI Git Commit Generator

This tool uses Google's Gemini AI to automatically generate Conventional Commits messages based on your staged changes. It runs in a Docker container to ensure a consistent environment.

## Prerequisites

- [Docker](https://www.docker.com/) installed and running.
- [Git](https://git-scm.com/) installed.
- A Google Gemini API Key. You can get one from [Google AI Studio](https://aistudio.google.com/).

## Setup

1.  **Navigate to the directory:**
    ```bash
    cd /path/to/gemini-cli
    ```

2.  **Create a `.env` file:**
    Create a file named `.env` in this directory and add your API key:
    ```env
    GEMINI_API_KEY=your_api_key_here
    ```

3.  **Build the Docker image:**
    Build the local Docker image that will be used by the script.
    ```bash
    docker build -t gemini-local .
    ```

## Usage

1.  **Stage your changes:**
    Add the files you want to commit to the staging area.
    ```bash
    git add <files>
    ```

2.  **Run the script:**
    Execute the `gitCommit.sh` script.
    ```bash
    ./gitCommit.sh
    ```

3.  **Select a Model:**
    The script will prompt you to choose a Gemini model:
    - `gemini-2.5-pro`
    - `gemini-2.5-flash` (Default)
    - `gemini-3-flash-preview`
    - `gemini-3-pro-preview`

4.  **Review and Commit:**
    - The script will generate a commit message.
    - Review the suggested message.
    - Type `y` to confirm and create the commit, or any other key to abort.

## Customization

You can modify `gitCommit.sh` to change the default model or adjust the prompt used for generation.
