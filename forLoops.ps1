
$Body = @{
    tenant = "tenant.saasit.com"
    username = "UN"
    password = "PW"
    role = "role"
}

$authCode = Invoke-RestMethod -Method 'POST' -Uri "https://tenant.saasit.com/api/rest/authentication/login" -Body $body


$headers = @{
    Authorization=$authCode
    Content='application/json'
}

$SubjectLine = Read-Host "Enter Incident Subject Line"


$searchQuery = Invoke-RestMethod -Method 'GET' -Uri "https://tenant.saasit.com/api/odata/businessobject/incidents?`$filter=Subject eq '$SubjectLine'&?filter=Status eq 'Logged'" -Headers $headers 

#Attempt to multithread, but need PowerShell 7 to run this. *Cries*
#Also please note the Ivanti API will only let you run this at about 25 incidents, so you will need to rerun the script if there are a lot of incidents.

<#Workflow TestingMultiThread{
    ForEach -parallel($object in $searchQuery.value) {
        $recIdofIncident = $object.recID
        Write-Output "Deleting Inc#" $object.IncidentNumber
        Invoke-RestMethod -Method 'DELETE' -Uri "https://tenant.saasit.com/api/odata/businessobject/incidents('$recIdofIncident')" -Headers $headers
    }
} TestingMultiThread#>

<#ForEach ($object in $SearchQuery.value){
$recIdofIncident = $object.recId
$recIdofIncident
}


$recIdofIncident | ForEach-Object -Parallel {
    $object.IncidentNumber
}#>

ForEach ($object in $searchQuery.value) {
    $recIdofIncident = $object.recID
    Write-Output "Deleting Inc#" $object.IncidentNumber
    Invoke-RestMethod -Method 'DELETE' -Uri "https://tenant.saasit.com/api/odata/businessobject/incidents('$recIdofIncident')" -Headers $headers
}
