$Body = @{
    tenant = "tenant.saasit.com"
    username = "UN" #enter username here
    password = "PW" #enter apssword here
    role = "IT"
}

$authCode = Invoke-RestMethod -Method 'POST' -Uri "https://becn.saasit.com/api/rest/authentication/login" -Body $body


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


$ignoreLine = Invoke-RestMethod -Method 'POST' -Uri "https://becn.saasit.com/api/odata/businessobject/TenantEmailSubjectLines" -Body $fields -Headers $headers


$Output = Write-Host "'$SubjectLine' added to ignore list."


$searchQuery = Invoke-RestMethod -Method 'GET' -Uri "https://becn.saasit.com/api/odata/businessobject/incidents?`$filter=Subject eq '$SubjectLine'" -Headers $headers 

#&?filter=Status eq 'Logged' <- for any additional filters
#Be sure this subject line is distinctive
#Otherwise tickets that are not looping will be deleted.

ForEach ($object in $searchQuery.value) {
    $recIdofIncident = $object.recID
    Write-Output "Deleting Inc#" $object.IncidentNumber
    Invoke-RestMethod -Method 'DELETE' -Uri "https://becn.saasit.com/api/odata/businessobject/incidents('$recIdofIncident')" -Headers $headers
}
