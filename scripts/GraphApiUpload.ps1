# PowerShell Script: Upload files to OneDrive via Microsoft Graph API
# DISCLAIMER: This requires registering an Azure AD app and granting appropriate Graph API permissions.

# 1. Set the variables
$tenantId = "26200d13-c3d5-4f3a-8d14-c5b0339e8ca8"
$clientId = "0b0f956e-767e-4118-b803-1f9d5c21425a"
$clientSecret = "cg48Q~J8mPcuQbpt8ce.i3jqUaA-c46.9Td5Gbsu"
$userEmail = "alice@darksystems120.onmicrosoft.com" 
# Change this to the email of the user you want to upload files for
$localFolderPath = "C:\Users\a84302994\Documents\sss\Projects\M365-Migration-Sim\testdata\AliceFiles"
# Change this to the local folder path containing files to upload

# 2. Get an access token
$body = @{
    grant_type    = "client_credentials"
    scope         = "https://graph.microsoft.com/.default"
    client_id     = $clientId
    client_secret = $clientSecret
}
$tokenResponse = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -Body $body
$token = $tokenResponse.access_token

# 3. Get the user ID from the email
$user = Invoke-RestMethod -Headers @{ Authorization = "Bearer $token" } `
    -Uri "https://graph.microsoft.com/v1.0/users/$userEmail"
$userId = $user.id

# 4 Upload each file in the folder to OneDrive root
$files = Get-ChildItem -Path $localFolderPath
foreach ($file in $files) {
    $filePath = Join-Path $localFolderPath $file
    $fileContent = [System.IO.File]::ReadAllBytes($filePath)

   $uploadUrl = "https://graph.microsoft.com/v1.0/users/${userId}/drive/root:/$($file.Name):/content"
    Invoke-RestMethod - Method Put -Uri $uploadUrl -Headers @{ Authorization = "Bearer $token"} -Body $fileContent -ContentType "application/octet-stream"

    Write-Host "Uploaded $file"
}

Write-Host "All files uploaded successfully to OneDrive for $userEmail"