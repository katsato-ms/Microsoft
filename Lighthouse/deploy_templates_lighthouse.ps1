# テナントを指定
$tenantId = "<your tenant id>"

# サブスクリプション ID を指定
$subscriptionId = "<your subscription id>"

# Azure PowerShell にログイン
Connect-AzAccount -Tenant $tenantId -Subscription $subscriptionId

# デプロイのロケーションを指定
$location = "japaneast"

# -----------------------------------------------------------
# Lighthouse 設定
# -----------------------------------------------------------

# テンプレート ファイル・パラメータ ファイルを指定
$templateFilePath = ".\template_lighthouse.json"
$templateParameterFilePath = ".\template_lighthouse_parameters.json"

# テンプレートをデプロイ
New-AzDeployment -Name "lighthouse" -Location $location -TemplateFile $templateFilePath -TemplateParameterFile $templateParameterFilePath

