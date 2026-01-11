#!/usr/bin/env sh
set -eu

echo "It only runs gemini in docker with the selected model with current folder mounted as /workdir in docker container"

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

docker run --rm -it --env-file "$DOT_ENV_FILE" -v ./:/workdir -w /workdir gemini-local-helper --model "$MODEL"