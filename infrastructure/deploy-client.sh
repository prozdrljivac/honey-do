#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# 1. set tf vars as .env vars in app client
terraform -chdir="$SCRIPT_DIR" output -json > "$SCRIPT_DIR/test-variables.json"
jq -r '
    "API_URL=\(.api_url.value)"
' test-variables.json > .env.test
# 2. build client
# 3. upload the build files to s3
