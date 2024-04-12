# パラメーターを指定
$subscriptionId = "your subscription id"
$resourceGroupName = "use your resource group name"
$capacityName = "use your capacity name"
$location = "eastus"
$numberOfUnits = 1
$crossGeoCompute = "Allowed"
$geo = "US"

# Azure PowerShell に接続
Connect-AzAccount -SubscriptionId $subscriptionId

# CfS SCU を作成/更新
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
Write-Host("response.StatusCode:" + $response.StatusCode)
Write-Host("response.Content:" + $response.Content)