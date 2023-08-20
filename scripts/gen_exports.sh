#!/bin/bash

EXPORTS=""
FILES=$(ls $1)
set -f
for FILE in $FILES; do
  EXPORTS="${EXPORTS}export * from \"./${FILE/.ts}\"\n";
done;
echo -e "$EXPORTS" >> "$1"/index.ts
