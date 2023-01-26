
$Body = @{
    tenant = "tenant"
    username = "username"
    password = "pw"
    role = "Admin"
}

$authCode = Invoke-RestMethod -Method 'POST' -Uri "https://saasit.com/api/rest/authentication/login" -Body $body


$headers = @{
    Authorization=$authCode
    Content='application/json'
}

$SubjectLine = Read-Host "Enter Incident Subject Line"


$searchQuery = Invoke-RestMethod -Method 'GET' -Uri "https://saasit.com/api/odata/businessobject/incidents?`$filter=Subject eq '$SubjectLine'&?filter=Status eq 'Logged'" -Headers $headers 

forEach ($object in $searchQuery.value)
{
    $recIdofIncident = $object.recID
    Write-Output "Deleting Inc#" $object.IncidentNumber
    Invoke-RestMethod -Method 'DELETE' -Uri "https://saasit.com/api/odata/businessobject/incidents('$recIdofIncident')" -Headers $headers
}





