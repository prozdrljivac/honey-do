#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 1. Capture terraform output once
TF_OUTPUT=$(terraform -chdir="$SCRIPT_DIR" output -json)

# 2. Set env vars for frontend
jq -r '
    "VITE_API_BASE_URL=\(.api_url.value)",
    "VITE_COGNITO_USER_POOL_ID=\(.user_pool_id.value)",
    "VITE_COGNITO_CLIENT_ID=\(.user_pool_client_id.value)"
' <<< "$TF_OUTPUT" > "../frontend/.env.local"

# 3. Build frontend
cd ../frontend || { echo "Failed to cd into frontend"; exit 1; }
npm run build

# 4. Sync to S3
CLIENT_ROOT_DIR_NAME=$(jq -r '.client_root_dir_name.value' <<< "$TF_OUTPUT")
aws s3 sync dist/ "s3://$CLIENT_ROOT_DIR_NAME/" --delete

echo "Deploy complete!"
