
$Body = @{
    tenant = "tenant.saasit.com"
    username = "UN"
    password = "PW"
    role = "Admin"
}

$authCode = Invoke-RestMethod -Method 'POST' -Uri "https://tenant.saasit.com/api/rest/authentication/login" -Body $body


$headers = @{
    Authorization=$authCode
    Content='application/json'
}

$SubjectLine = Read-Host "Enter Incident Subject Line"

$fields = "{
    'SubjectLine': '$SubjectLine',
    'ParentLink_Category': 'TenantEmailConfiguration',
    'ParentLink_RecID': '07E042A328B3449580AE415E3677E7A8',
    'ParentLink': 'null',
    'LineType': 'IgnoreSubjectLine',
    'ReadOnly': 'false'
}"


$ignoreLine = Invoke-RestMethod -Method 'POST' -Uri "https://tenant.saasit.com/api/odata/businessobject/TenantEmailSubjectLines" -Body $fields -Headers $headers

#This is an example of a loop

$Output = Write-Host "'$SubjectLine' added to ignore list."


$searchQuery = Invoke-RestMethod -Method 'GET' -Uri "https://tenant.saasit.com/api/odata/businessobject/incidents?`$filter=Subject eq '$SubjectLine'" -Headers $headers 
#&?filter=Status eq 'Logged' <- for any additional filters

ForEach ($object in $searchQuery.value) {
    $recIdofIncident = $object.recID
    Write-Output "Deleting Inc#" $object.IncidentNumber
    Invoke-RestMethod -Method 'DELETE' -Uri "https://tenant.saasit.com/api/odata/businessobject/incidents('$recIdofIncident')" -Headers $headers
}



