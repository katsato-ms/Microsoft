## Try with Powershell

````powershell
$guid = New-Guid()
$policyLocation = "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/.../xxx.json"
$definition = New-AzPolicyDefinition -Name $guid -Policy $policyLocation
$definition
````
