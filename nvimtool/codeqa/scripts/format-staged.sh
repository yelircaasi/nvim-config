#!/bin/sh

staged=$(git diff --cached --name-only)

if [ -z "$staged" ]; then
  echo "No files staged."
  exit 0
else
  echo "Formatting staged files."
  treefmt $staged
  git add $staged
fi
