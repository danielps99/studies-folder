#!/usr/bin/env sh
set -eu

# Check staged changes
if [ -z "$(git diff --staged)" ]; then
  echo "No staged changes."
  exit 1
fi

PROMPT='Generate a Git commit message using Conventional Commits.

Rules:
- First line: concise subject, max 72 characters
- Blank line after subject
- Commit body as bullet points
- Use present tense
- Do not include markdown
- Do not include explanations outside the commit message

Git diff:
'

echo "Select a model:"
echo "1) gemini-2.5-pro"
echo "2) gemini-2.5-flash - DEFAULT"
echo "3) gemini-3-flash-preview"
echo "4) gemini-3-pro-preview"
echo "Just enter for use default gemini-2.5-flash"

read -p "Enter choice [1-4]: " choice
case $choice in
  1) MODEL="gemini-2.5-pro" ;;
  2) MODEL="gemini-2.5-flash" ;;
  3) MODEL="gemini-3-flash-preview" ;;
  4) MODEL="gemini-3-pro-preview" ;;
  *) MODEL="gemini-2.5-flash" ;; # Default
esac

echo "Using model: $MODEL"

DOT_ENV_FILE="$(cd "$(dirname "$0")" && pwd)/.env"

echo "Using .env file: $DOT_ENV_FILE"

# Generate commit message
COMMIT_MSG="$(git diff --staged | docker run --rm -i --env-file "$DOT_ENV_FILE" gemini-local --model "$MODEL" "$PROMPT")"

# Safety check
if [ -z "$COMMIT_MSG" ]; then
  echo "Failed to generate commit message."
  exit 1
fi

# Show suggested commit message
echo
echo "Suggested commit message:"
echo "----------------------------------------"
printf "%s\n" "$COMMIT_MSG"
echo "----------------------------------------"
echo

# Ask for confirmation
printf "Do you want to commit with this message? [y/N] "
read ANSWER

case "$ANSWER" in
  y|Y)
    printf "%s\n" "$COMMIT_MSG" | git commit -F -
    echo "Commit created."
    ;;
  *)
    echo "Commit aborted."
    ;;
esac