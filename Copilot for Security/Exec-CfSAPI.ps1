# テナント ID を指定
$tenantId = "your tenant id"

# セッション名、プロンプトを指定
$sessionName = "your session title"
$prompt = "your prompt that you want to ask to Copilot for Security"

# Azure PowerSHell に接続
Connect-AzAccount -Tenant $tenantId

# securitycopilot.microsoft.com をリソースとして Bearer トークンを取得
$token = Get-AzAccessToken -ResourceUrl "https://api.securitycopilot.microsoft.com"

# header 作成
$bearertoken = "Bearer " + $token.Token
$headers = @{
    "Authorization"= $bearerToken
    "Content-Type"="application/json"
}

# sessions ##########################################################################
# セッション作成用リクエスト作成
$request = @{
    Uri         = "https://api.securitycopilot.microsoft.com/geo/eastus/sessions"
    Body        = '{"name":"' + $sessionName + '","source":"immersive"}'
    Headers     = $headers
    Method      = 'POST'
}

# セッション作成 API 実行
$response = Invoke-WebRequest @request

# セッション ID の取得
$sessionId = ($response.Content | ConvertFrom-Json).sessionId


# prompts ##########################################################################
# プロンプト送信用リクエスト作成
$request = @{
    Uri         = "https://api.securitycopilot.microsoft.com/geo/eastus/sessions/$sessionId/prompts"
    Body        = '{"promptType":"Prompt","content":"' + $prompt + '","sessionId":"' + $sessionId + '","source":"immersive"}'
    Headers     = $headers
    Method      = 'POST'
}

# プロンプト送信 API 実行
$response = Invoke-WebRequest @request

# プロンプト ID の取得
$promptId = ($response.Content | ConvertFrom-Json).promptId


# evaluations ##########################################################################
# 評価実行用リクエスト作成
$request = @{
    Uri         = "https://api.securitycopilot.microsoft.com/geo/eastus/sessions/$sessionId/prompts/$promptId/evaluations"
    Body        = '{"sessionId":"' + $sessionId + '","promptId":"' + $promptId + '"}'
    Headers     = $headers
    Method      = 'POST'
}

# 評価実行 API 実行
$response = Invoke-WebRequest @request

# 評価 ID の取得
$evaluationId = ($response.Content | ConvertFrom-Json).evaluation.evaluationId


# evaluations の取得 ##########################################################################
# プロンプト回答取得リクエスト作成
$request = @{
    Uri         = "https://api.securitycopilot.microsoft.com/geo/eastus/sessions/$sessionId/prompts/$promptId/evaluations/$evaluationId"
    Headers     = $headers
    Method      = 'GET'
}

# 評価が完了するまで繰り返し
do {
    $response = Invoke-WebRequest @request
    $state = ($response.Content | ConvertFrom-Json).state
    Write-Output $state
    Start-Sleep -Seconds 5
} while ($state -eq "Created" -or $state -eq "Running")

# 結果の表示
$response.Content | ConvertFrom-Json




