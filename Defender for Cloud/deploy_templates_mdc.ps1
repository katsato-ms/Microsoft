# テナントを指定
$tenantId = "<your tenant id>"

# サブスクリプション ID を指定
$subscriptionId = "<your subscription id>"

# パラメータ
$resourceGroupName = "MyResourceGroup"
$location = "Japan East"
$logAnalyticsWorkspaceName = "MyLogAnalyticsWorkspace"

$dfcEmails = "admin@contoso.com;admin2@contoso.com"

$workspaceId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.OperationalInsights/workspaces/$logAnalyticsWorkspaceName"

# Azure PowerShell にログイン
Connect-AzAccount -Tenant $tenantId -Subscription $subscriptionId


# -----------------------------------------------------------
# Defender for Cloud を有効化、連続エクスポート設定
# -----------------------------------------------------------

# テンプレート ファイルを指定
$templateFilePath = ".\template_mdc.json"

# テンプレート パラメータ オブジェクトを指定
$templateParameterObject = @{
    "resourceGroupName" = $resourceGroupName
    "resourceGroupLocation" = $location
    "emails" = $dfcEmails
    "logAnalyticsWorkspaceName" = $logAnalyticsWorkspaceName
    "workspaceResourceId" = $workspaceId
}

# テンプレートをデプロイ
New-AzDeployment -Name "mdcsetting" -Location $location -TemplateFile $templateFilePath -TemplateParameterObject $templateParameterObject

