# Input bindings are passed in via param block.
param($Timer)

# モジュールのインポート
Import-Module -Name Az.Accounts
Import-Module -Name Az.Storage

# 先月の開始日と終了日を取得
$LastMonthStart = (Get-Date).AddMonths(-1).ToString("yyyyMM01")
$LastMonthEnd = (Get-Date).AddDays(- (Get-Date).Day).ToString("yyyyMMdd")

# パラメータを指定
$resourceGroup = "myrg"
$StorageAccountName = "mystorage"
$ContainerName = "billing"
$BlobPathPrefix = "csv/sub1-month-actual-cost/$LastMonthStart-$LastMonthEnd/"  # GUID 部分を含まない共通パス
$DownloadFolder = "_tmp"  # ダウンロード先フォルダ
$ExtractFolder = "$DownloadFolder/extracted"  # 解凍先フォルダ
$MergedCsvPath = "$DownloadFolder/billing_data.csv"  # 結合後のCSVファイル

$OutputJson = "billing_summary.txt"  # LogicApps で使用するため txt ファイルで保存
$OutputBlobName = "json/$LastMonthStart-billing_summary.txt"

# フォルダ作成
foreach ($folder in @($DownloadFolder, $ExtractFolder)) {
    if (!(Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder | Out-Null
    }
}

### Step 1: BLOB ダウンロードと解凍処理 ### ### ### ### ### ### ### ### ### ### ###  

# Azure にログイン（マネージド ID を使用）
Connect-AzAccount -Identity
# Connect-AzAccount

# ストレージアカウントのキーなしで認証する（マネージド ID 使用）
$StorageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $StorageAccountName
$Context = New-AzStorageContext -StorageAccountName $StorageAccount.StorageAccountName -UseConnectedAccount

# 指定したパスに一致する BLOB をリストアップ
$Blobs = Get-AzStorageBlob -Container $ContainerName -Context $Context | Where-Object { $_.Name -like "$BlobPathPrefix*" }

# BLOB ダウンロードと解凍処理
foreach ($Blob in $Blobs) {
    $BlobName = $Blob.Name
    $DownloadPath = "$DownloadFolder\$($BlobName -replace '[\/]', '_')"  # ファイル名を整形
    Write-Host "ファイルをダウンロード: $BlobName -> $DownloadPath"
    
    Get-AzStorageBlobContent -Container $ContainerName -Blob $BlobName -Destination $DownloadPath -Context $Context -Force
    Write-Host "ダウンロード完了: $DownloadPath"

    # `.gz` のみ解凍処理を実施
    if ($DownloadPath -like "*.gz") {
        $ExtractedCsvPath = "$ExtractFolder\$($BlobName -replace '[\/]', '_')"
        $ExtractedCsvPath = $ExtractedCsvPath -replace '\.gz$', ''
        Write-Host "解凍中: $DownloadPath -> $ExtractedCsvPath"

        # Gzip 解凍
        $FileStream = [System.IO.File]::OpenRead($DownloadPath)
        $DecompressedStream = New-Object System.IO.Compression.GzipStream $FileStream, ([System.IO.Compression.CompressionMode]::Decompress)
        $FileOutput = [System.IO.File]::Create($ExtractedCsvPath)
        $DecompressedStream.CopyTo($FileOutput)
        $DecompressedStream.Close()
        $FileStream.Close()
        $FileOutput.Close()

        Write-Host "解凍完了: $ExtractedCsvPath"
    }
}

### Step 2: CSV マージ処理 ### ### ### ### ### ### ### ### ### ### ###  
Write-Host "CSV マージ処理を開始..."

# extracted フォルダにあるすべての CSV ファイルを取得
$CsvFiles = Get-ChildItem -Path $ExtractFolder -Filter "*.csv" | Select-Object -ExpandProperty FullName

# 変数初期化
$AllData = @()

foreach ($CsvFile in $CsvFiles) {
    Write-Host "CSV 読み込み: $CsvFile"
    # オブジェクトとして CSV を取り込み、マージ (なのでヘッダ列が重複することはない)
    $Data = Import-Csv -Path $CsvFile
    $AllData += $Data
}

# CSV に書き出し
if ($AllData.Count -gt 0) {
    Write-Host "マージ完了。CSV に出力: $MergedCsvPath"
    $AllData | Export-Csv -Path $MergedCsvPath -NoTypeInformation -Encoding UTF8
    Write-Host "CSV マージ処理完了: $MergedCsvPath"
} else {
    Write-Host "マージ対象の CSV が見つかりませんでした。"
}

### Step 3: manifest ファイルチェック ### ### ### ### ### ### ### ### ### ### ###  

# _tmp フォルダを検索し、manifest.json のファイルを取得
$ManifestFile = Get-ChildItem -Path "_tmp" -Filter "*manifest.json" -File -Recurse | Select-Object -ExpandProperty FullName

# manifest.json が見つからない場合の処理
if (-not $ManifestFile) {
    Write-Host "_tmp フォルダ内に manifest.json が見つかりませんでした。スクリプトを終了します。"
    exit 1
}

Write-Host "使用する manifest.json: $ManifestFile"

# manifest.json を読み込む
$ManifestData = Get-Content -Path $ManifestFile | ConvertFrom-Json

# manifest.json に記載されている総データ行数を計算
$ExpectedRowCount = ($ManifestData.blobs | Measure-Object -Property dataRowCount -Sum).Sum

Write-Host "manifest.json に記載されている合計行数: $ExpectedRowCount"

# 実際のマージ後 CSV の行数を取得
$ActualRowCount = (Get-Content -Path $MergedCsvPath | Measure-Object -Line).Lines -1

Write-Host "マージ後の CSV ファイルの行数: $ActualRowCount"

# 行数を比較
if ($ActualRowCount -eq $ExpectedRowCount) {
    Write-Host "行数が一致しました: $ActualRowCount 行"
} else {
    Write-Host "行数が一致しません！ (期待値: $ExpectedRowCount, 実際: $ActualRowCount)"
}

### Step 4: 集計処理 ### ### ### ### ### ### ### ### ### ### ###  

# 最終的な CSV を読み込む
$BillingData = Import-Csv -Path $MergedCsvPath


# costInBillingCurrency by resourceGroupName で集計
$Summary = $BillingData | Group-Object -Property resourceGroupName | ForEach-Object {
    [PSCustomObject]@{
        ResourceGroup = $_.Name
        TotalCost     = [math]::Round(($_.Group | Measure-Object -Property costInBillingCurrency -Sum).Sum, 2)
    }
}

# JSON データを出力
$Summary | ConvertTo-Json -Depth 2 | Set-Content -Path $OutputJson -Encoding UTF8
Write-Host "save $OutputJson"


### Step 5: BLOB アップロード ### ### ### ### ### ### ### ### ### ### ###  

Write-Host "JSON ファイルをアップロード: $OutputBlobName"
Set-AzStorageBlobContent -Container $ContainerName -File $OutputJson -Blob $OutputBlobName -Context $Context -Force
Write-Host "アップロード完了: $OutputBlobName"


# _tmp 配下のフォルダやファイルを削除
Remove-Item -Path $DownloadFolder -Recurse -Force
Write-Host "ローカルファイルを削除しました。"
Write-Host "全処理が完了しました。"

