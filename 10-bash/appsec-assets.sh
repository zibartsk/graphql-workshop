#!/bin/bash

# load .env file
set -o allexport
source .env
set +o allexport

# API key to API requests auth token
function getToken {
    RESP=$(curl -s --request POST \
        --url https://cloudinfra-gw.portal.checkpoint.com/auth/external \
        --header 'content-type: application/json' \
        --data "{\"clientId\":\"$1\" ,\"accessKey\":\"$2\" }")
    TOKEN=$(echo "$RESP" | jq -r '.data.token')
}

function getAssets {
    read -r -d '' QUERY <<'EOF'
    query ExampleQuery {
        getAssets(userDefined:true) {
          status
            assets {
              id
              name 
              assetType
            }
        }
      }
EOF
    BODY=$(jq -r -n --arg Q "$QUERY" '{query:$Q}')
    

    RESP=$(curl -s --request POST \
        --url https://cloudinfra-gw.portal.checkpoint.com/app/i2/graphql/V1 \
        --header "authorization: Bearer ${TOKEN}" \
        --header 'content-type: application/json' \
        --data "$BODY")
    RES=$(echo "$RESP" | jq -r '.')
    echo "$RES"
}


getToken "$APPSEC_API_KEY" "$APPSEC_API_KEY_SECRET"
echo $TOKEN

getAssets | jq -r '.data.getAssets.assets[] | "\(.id) \(.name) \(.assetType)"'