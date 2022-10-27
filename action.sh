#!/bin/bash

echo "Running Netlify CLI command..."
echo "> npx netlify-cli $*"

set -e
OUTPUT=$(bash -c "npx netlify-cli $*" | tr '\n' ' ')
set +e

NETLIFY_OUPUT=$(echo "$OUTPUT")

echo "NETLIFY_OUTPUT=$NETLIFY_OUPUT" >> $GITHUB_OUTPUT
