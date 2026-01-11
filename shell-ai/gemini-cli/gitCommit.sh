#!/usr/bin/env sh
set -eu

# Check staged changes
if [ -z "$(git diff --staged)" ]; then
  echo "No staged changes."
  exit 1
fi

PROMPT='Generate a Git commit message following the Conventional Commits specification.

Requirements:
- Use the format: <type>(<optional scope>): <subject>
- Subject line must be in present tense, imperative mood, and no longer than 72 characters
- Do not end the subject line with a period
- Add a blank line after the subject
- Write the commit body as bullet points starting with "- "
- Use present tense throughout
- Describe what and why, not how
- Do not use markdown
- Do not add explanations, titles, or comments outside the commit message
- Output only the commit message

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

DOT_ENV_FILE="$(dirname "$(readlink -f "$0")")/.env"

echo "Using .env file: $DOT_ENV_FILE"

# Generate commit message
COMMIT_MSG="$(git diff --staged | docker run --rm -i --env-file "$DOT_ENV_FILE" gemini-local-helper --model "$MODEL" "$PROMPT")"

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