## Try with Powershell

````powershell
$guid = New-Guid
$policyLocation = "https://raw.githubusercontent.com/katsato-ms/Microsoft/refs/heads/main/Policy/policyDefinitions/.../xxx.json"
$definition = New-AzPolicyDefinition -Name $guid -Policy $policyLocation
$definition
````
