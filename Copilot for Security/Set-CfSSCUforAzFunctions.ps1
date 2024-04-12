using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# パラメーターを指定
$subscriptionId = "your subscription id"
$resourceGroupName = "use your resource group name"
$capacityName = "use your capacity name"
$location = "eastus"
$numberOfUnits = 1
$crossGeoCompute = "Allowed"
$geo = "US"

# リクエストから SCU 数を取得 (Body に {"numberOfUnits":"2"} の形式で指定)
# $numberOfUnits = [int]$Request.Body.numberOfUnits

# Azure PowerShell に接続
Connect-AzAccount -Identity

# REST API の body を作成
$body = @{
    "type" = "Microsoft.SecurityCopilot/capacities"
    "name" = $capacityName
    "location" = $location
    "properties" = @{
        "numberOfUnits" = $numberOfUnits
        "crossGeoCompute" = $crossGeoCompute
        "geo" = $geo
    }
} | ConvertTo-Json

# path を指定
$path = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.SecurityCopilot/capacities/$capacityName" + "?api-version=2023-12-01-preview"

# REST API を実行し作成
$response = Invoke-AzRestMethod -Path $path -Method Put -Payload $body

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $response.statuscode
    Body = $response.content
})