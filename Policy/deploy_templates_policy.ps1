# テナントを指定
$tenantId = "<your tenant id>"

# サブスクリプション ID を指定
$subscriptionId = "<your subscription id>"

# パラメータ
$resourceGroupName = "MyResourceGroup"
$location = "Japan East"


# Azure PowerShell にログイン
Connect-AzAccount -Tenant $tenantId -Subscription $subscriptionId


# -----------------------------------------------------------
# ポリシー割り当てと適用除外の作成
# -----------------------------------------------------------

# テンプレート ファイルを指定
$templateFilePath = ".\template_policy.json"

# テンプレート パラメータ オブジェクトを指定
$templateParameterObject = @{
    "exemptionResourceGroupName" = $resourceGroupName
}   

# テンプレートをデプロイ
New-AzDeployment -Name "policyassignment" -Location $location -TemplateFile $templateFilePath -TemplateParameterObject $templateParameterObject
