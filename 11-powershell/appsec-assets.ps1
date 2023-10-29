get-content .env | foreach {
    $name, $value = $_.split('=')
    Write-Host "Setting $name env variable"
    set-content env:\$name $value
}

# POST https://cloudinfra-gw.portal.checkpoint.com/auth/external
# Content-Type: application/json

# {"clientId":"{{apiKey}}","accessKey":"{{apiKeySecret}}"}
function Get-AppSecToken {
    $body = @{
        clientId = $env:APPSEC_API_KEY
        accessKey = $env:APPSEC_API_KEY_SECRET
    }
    $loginUrl = "https://cloudinfra-gw.portal.checkpoint.com/auth/external"
    $response = Invoke-RestMethod -Method Post -Uri $loginUrl -Body $body
    if ($response.success) {
        return $response.data.token
    }
    return $null
}


# POST https://cloudinfra-gw.portal.checkpoint.com/app/i2/graphql/V1 HTTP/1.1
# Authorization: Bearer {{token}}
# Content-Type: application/json
# X-REQUEST-TYPE: GraphQL

# query ExampleQuery {
#   getAssets(userDefined:true) {
#     status
#       assets {
#         id
#         name 
#         assetType
#       }
#   }
# }

function Get-AppSecAssets($token) {
    $apiUrl = "https://cloudinfra-gw.portal.checkpoint.com/app/i2/graphql/V1"
    $gqlQuery = @"
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
"@
    $body = @{
        query = $gqlQuery
    } | ConvertTo-Json -Depth 10
    $headers = @{
        "Content-Type" = "application/json";
        "Authorization" = "Bearer $token";
    }
    # Write-Host $headers
    # Write-Host $body

    $response = Invoke-RestMethod -Method Post -Uri $apiUrl -Body $body -Headers $headers

    # Write-Host ($response | ConvertTo-Json -Depth 10)

    if ($response.data.getAssets.status -eq "done") {
        return $response.data.getAssets.assets
    }
    return @()
}

function demo() {
    $token = Get-AppSecToken

    Write-Host
    $assets = Get-AppSecAssets $token
    $assets | foreach {
        Write-Host $_.id, $_.assetType, $_.name
    }
}

demo
