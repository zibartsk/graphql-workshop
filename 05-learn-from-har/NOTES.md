idea: learn from existing browser based client calls captured in browser Developer Tools into HAR file

remember: remove credentials from HAR, if sharing; even short term tokens (remember recent Okta incident)

```powershell
$harFile="/Users/mkoldov/Downloads/_delete/portal.checkpoint.com.har"
$apiUrl="https://cloudinfra-gw.portal.checkpoint.com/app/i2//graphql"
$har = gc $harFile | ConvertFrom-Json
$entries = $har.log.entries
$entries | select -first 2
$gqlEntries = $entries | ? { ($_.request.method -eq 'POST') -and ($_.request.url -eq $apiUrl) }
$gqlEntries

$postData = $gqlEntries | % { $_.request.postData.text | ConvertFrom-Json  }
$postData
# we have operationName, query and variables
$operations = $postData | select-object operationName  | Sort-Object operationName -Unique
$operations

# newDockerProfile seems interesting
$postData | ? { $_.operationName -eq 'newDockerProfile' } | fl

$postData | ? { $_.operationName -eq 'newDockerProfile' } | % { $_.variables | ConvertTo-Json -Depth 10 }

# and updateDockerProfile
$postData | ? { $_.operationName -eq 'updateDockerProfile' } | fl

$postData | ? { $_.operationName -eq 'updateDockerProfile' } | % { $_.variables | ConvertTo-Json -Depth 10 }

# anotate gqlEntries with operationName, so we may check server response
$gqlEnhanced = $gqlEntries | % { $_ | Add-Member -NotePropertyName bodyParsed -NotePropertyValue ($_.request.postData.text | ConvertFrom-Json); $_ }
$gqlEnhanced

# now select by bodyParsed.operationName
$gqlEnhanced | ? { $_.bodyParsed.operationName -eq "newDockerProfile" } | % { ($_.response.content.text | ConvertFrom-Json).data.newDockerProfile }

# Profiles
$gqlEnhanced | ? { $_.bodyParsed.operationName -eq "Profiles" } | % { ($_.response.content.text | ConvertFrom-Json).data }
# query not matching operationName - e.g. Profiles bs getProfiles
$gqlEnhanced | ? { $_.bodyParsed.operationName -eq "Profiles" } | % { ($_.response.content.text | ConvertFrom-Json).data.getProfiles } | ft
```