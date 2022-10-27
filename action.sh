#!/bin/bash

echo "Running Netlify CLI command..."
echo "> npx netlify-cli $*"

set -e
OUTPUT=$(bash -c "npx netlify-cli $*" | tr '\n' ' ')
set +e

echo "NETLIFY_OUTPUT=$(echo "$OUTPUT")" >> $GITHUB_OUTPUT
