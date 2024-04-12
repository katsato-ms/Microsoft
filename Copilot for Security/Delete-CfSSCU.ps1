# パラメーターを指定
$subscriptionId = "your subscription id"
$resourceGroupName = "your resource group name"
$capacityName = "your capacity name"

# Azure PowerShell に接続
Connect-AzAccount -SubscriptionId $subscriptionId

# path を指定
$path = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.SecurityCopilot/capacities/$capacityName" + "?api-version=2023-12-01-preview"

# リソースが存在することを確認
$response = Invoke-AzRestMethod -Path $path -Method Get

# REST API を実行し削除
If($response.StatusCode -eq 200) {
    $response = Invoke-AzRestMethod -Path $path -Method Delete
}

Write-Host("response.StatusCode:" + $response.StatusCode)
Write-Host("response.Content:" + $response.Content)