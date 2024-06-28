# テナントを指定
$tenantId = "<your tenant id>"

# サブスクリプション ID を指定
$subscriptionId = "<your subscription id>"

# パラメータ
$resourceGroupName = "MyResourceGroup"
$location = "Japan East"
$logAnalyticsWorkspaceName = "MyLogAnalyticsWorkspace"

$actionGroupName = "myActionGroup"
$shortName = "myAG"
$emailReceiverName = "myEmailReceiver"
$emailAddress = "example@contoso.com"
$smsReceiverName = "mySmsReceiver"
$countryCode = "81"
$phoneNumber = "09011111111"

$alertRuleName = "DefenderForCloudAlert"
$alertRuleDescription = "Alert rule for Defender for Cloud"

$workspaceId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.OperationalInsights/workspaces/$logAnalyticsWorkspaceName"
$actiongroupId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/microsoft.insights/actiongroups/$actionGroupName"

# Azure PowerShell にログイン
Connect-AzAccount -Tenant $tenantId -Subscription $subscriptionId

# -----------------------------------------------------------
# リソース グループ / Log Analytics ワークスペースを作成
# -----------------------------------------------------------

# テンプレート ファイルを指定
$templateFilePath = ".\template_monitorsetting.json"

# テンプレート パラメータ オブジェクトを指定
$templateParameterObject = @{
    "resourceGroupName" = $resourceGroupName
    "resourceGroupLocation" = $location
    "logAnalyticsWorkspaceName" = $logAnalyticsWorkspaceName
}   

# テンプレートをデプロイ
New-AzDeployment -Name "monitorsetting" -Location $location -TemplateFile $templateFilePath -TemplateParameterObject $templateParameterObject


# -----------------------------------------------------------
# アクション グループを作成
# -----------------------------------------------------------

# テンプレート ファイルを指定
$templateFilePath = ".\Monitor\template_actiongroup.json"

# テンプレート パラメータ オブジェクトを指定
$templateParameterObject = @{
    "actionGroupName" = $actionGroupName
    "shortName" = $shortName
    "emailReceiverName" = $emailReceiverName
    "emailAddress" = $emailAddress
    "smsReceiverName" = $smsReceiverName
    "countryCode" = $countryCode
    "phoneNumber" = $phoneNumber
}

# テンプレートをデプロイ
New-AzResourceGroupDeployment -Name "actiongroup" -ResourceGroup $resourceGroupName -TemplateFile $templateFilePath -TemplateParameterObject $templateParameterObject


# -----------------------------------------------------------
# アラート ルールを作成
# -----------------------------------------------------------
# テンプレート ファイルを指定
$templateFilePath = ".\Monitor\template_alertrule.json"

$templateParameterObject = @{
    "alertRuleName" = $alertRuleName
    "alertRuleDescription" = $alertRuleDescription
    "workspaceId" = $workspaceId
    "actiongroupId" = $actiongroupId
}

# テンプレートをデプロイ
New-AzResourceGroupDeployment -Name "alertrule" -ResourceGroup $resourceGroupName -TemplateFile $templateFilePath -TemplateParameterObject $templateParameterObject
