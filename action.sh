#!/bin/bash

echo "Running Netlify CLI command..."
echo "> npx netlify-cli $*"

set -e
OUTPUT=$(bash -c "npx netlify-cli $*" | tr '\n' ' ')
set +e

NETLIFY_OUTPUT=$(echo "$OUTPUT")

echo "NETLIFY_OUTPUT=$NETLIFY_OUTPUT" >> $GITHUB_OUTPUT
