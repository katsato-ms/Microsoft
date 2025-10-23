# Microsoft Sentinel - Logs From Blob Storage Data Connector (CCP)

This repository contains an ARM template for a custom data connector (CCP: Codeless Connector Platform) that ingests logs from Azure Blob Storage into Microsoft Sentinel.

## Overview

This ARM template deploys a data connector solution that automatically ingests log files stored in Azure Blob Storage into Microsoft Sentinel workspace. It uses Event Grid to monitor blob creation events in real-time for efficient log collection.

## Features

- **Real-time Log Ingestion**: Monitor blob creation events using Event Grid
- **Customizable Data Connector**: Based on Codeless Connector Platform (CCP)
- **Automated Infrastructure Setup**: Automatic configuration of required storage queues, event subscriptions, and RBAC
- **Data Transformation**: Log data transformation and routing using Data Collection Rules (DCR)
- **Error Handling**: Failed message processing using Dead Letter Queue (DLQ)

## Architecture

```
Azure Blob Storage → Event Grid → Storage Queue → Microsoft Sentinel Data Connector → Log Analytics Workspace
```

### Deployed Resources

1. **Data Connector Definition**: Microsoft Sentinel custom data connector
2. **Data Collection Rule (DCR)**: Log data transformation and routing
3. **Log Analytics Table**: `LogsFromBlob_CL` custom table
4. **Event Grid System Topic**: Monitor blob creation events
5. **Storage Queues**: Notification queue and DLQ
6. **RBAC Role Assignments**: Grant necessary permissions

## Prerequisites

### Azure Resources
- Log Analytics workspace with Microsoft Sentinel enabled
- Azure Storage Account and container for storing log files

### Permissions
- **Log Analytics Workspace**: Contributor or higher
- **Storage Account**: Owner or User Access Administrator + Contributor

## Parameters

### Required Parameters

| Parameter Name | Type | Description |
|----------------|------|-------------|
| `workspace` | string | Log Analytics workspace name where Microsoft Sentinel is configured |
| `workspace-location` | string | Workspace region |
| `resourceGroupName` | string | Resource group name where Microsoft Sentinel is configured |
| `subscription` | string | Subscription ID where Microsoft Sentinel is configured |

### Configuration Information Required

The following information is required when configuring the data connector:

- **Service Principal ID**: Service principal ID for data collection (selectable after clicking `Grant tenant-wide admin consent` button)
- **Blob Container URI**: URI of the container where log files are stored
- **Storage Account Resource Group**: Resource group name of the storage account
- **Storage Account Location**: Region of the storage account
- **Storage Account Subscription**: Subscription ID of the storage account
- **Event Grid Topic Name**: Existing Event Grid topic name of the storage account (optional)

## Deployment Steps

### Deploy with Azure Portal

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fkatsato-ms%2FMicrosoft%2Frefs%2Fheads%2Fmain%2FSentinel%2FCCP%2FLogsFromBlob%2FmainTemplate-CCP-LogsFromBlob.json)


## Configuration Steps

### 1. Data Connector Configuration

1. Access Microsoft Sentinel portal
2. Select **Data connectors** → **Logs From Blob Storage (CCP)**
3. Enter required information:
   - Service Principal ID (selectable after clicking `Grant tenant-wide admin consent` button)
   - Blob Container URI
   - Storage Account details
4. Click **Connect**

### 2. Log Verification

If the data connector is working properly, you can verify logs with the following query:

```kql
LogsFromBlob_CL
| take 10
| project TimeGenerated, properties
```

## Log Schema

Schema for the created custom table `LogsFromBlob_CL` (assumes format when various diagnostic logs are saved to storage account):

| Column Name | Type | Description |
|-------------|------|-------------|
| `TimeGenerated` | datetime | Log generation time |
| `properties` | string | Log properties (JSON format) |

It's also possible to configure individual columns and use transformation rules to convert to appropriate format.

---

# Microsoft Sentinel - Logs From Blob Storage Data Connector (CCP)

このリポジトリには、Azure Blob Storage からログを Microsoft Sentinel に取り込むためのカスタムデータコネクタ（CCP: Codeless Connector Platform）の ARM テンプレートが含まれています。

## 概要

この ARM テンプレートは、Azure Blob Storage に保存されたログファイルを Microsoft Sentinel ワークスペースに自動的に取り込むためのデータコネクタソリューションをデプロイします。Event Grid を使用してリアルタイムでブロブ作成イベントを監視し、効率的なログ収集を実現します。

## 機能

- **リアルタイムログ取り込み**: Event Grid を使用したブロブ作成イベントの監視
- **カスタマイズ可能なデータコネクタ**: Codeless Connector Platform（CCP）ベース
- **自動インフラストラクチャ構築**: 必要なストレージキュー、イベントサブスクリプション、RBAC の自動設定
- **データ変換**: Data Collection Rules（DCR）を使用したログデータの変換・ルーティング
- **エラーハンドリング**: Dead Letter Queue（DLQ）を使用した失敗したメッセージの処理

## アーキテクチャ

```
Azure Blob Storage → Event Grid → Storage Queue → Microsoft Sentinel Data Connector → Log Analytics Workspace
```

### デプロイされるリソース

1. **データコネクタ定義**: Microsoft Sentinel のカスタムデータコネクタ
2. **データ収集ルール（DCR）**: ログデータの変換とルーティング
3. **Log Analytics テーブル**: `LogsFromBlob_CL` カスタムテーブル
4. **Event Grid システムトピック**: BLOB 作成イベントの監視
5. **ストレージキュー**: 通知キューと DLQ
6. **RBAC ロール付与**: 必要な権限の付与

## 必要な前提条件

### Azure リソース
- Microsoft Sentinel が有効化された Log Analytics ワークスペース
- ログファイルを保存する ストレージ アカウントとコンテナ

### 権限
- **Log Analytics ワークスペース**: 共同作成者以上
- **ストレージアカウント**: 所有者もしくはユーザーアクセス管理者 + 作成者

## パラメータ

### 必須パラメータ

| パラメータ名 | 型 | 説明 |
|------------|----|----|
| `workspace` | string | Microsoft Sentinel が設定されている Log Analytics ワークスペース名 |
| `workspace-location` | string | ワークスペースのリージョン |
| `resourceGroupName` | string | Microsoft Sentinel が設定されているリソースグループ名 |
| `subscription` | string | Microsoft Sentinel が設定されているサブスクリプション ID |

### 設定時に必要な情報

データコネクタの設定時に以下の情報を入力する必要があります：

- **Service Principal ID**: データ収集用のサービスプリンシパル ID (`Grant tenant-wide admin consent` ボタンで同意することで選択可能)
- **Blob Container URI**: ログファイルが保存されているコンテナの URI
- **Storage Account Resource Group**: ストレージアカウントのリソースグループ名
- **Storage Account Location**: ストレージアカウントのリージョン
- **Storage Account Subscription**: ストレージアカウントのサブスクリプション ID
- **Event Grid Topic Name**: ストレージ アカウントの既存の Event Grid トピック名（オプション）

## デプロイ手順

### Azure Portal でのデプロイ

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fkatsato-ms%2FMicrosoft%2Frefs%2Fheads%2Fmain%2FSentinel%2FCCP%2FLogsFromBlob%2FmainTemplate-CCP-LogsFromBlob.json)


## 設定手順

### 1. データコネクタの設定

1. Microsoft Sentinel ポータルにアクセス
2. **データコネクタ** → **Logs From Blob Storage (CCP)** を選択
3. 必要な情報を入力：
   - Service Principal ID (`Grant tenant-wide admin consent` ボタンで同意することで選択可能)
   - Blob Container URI
   - Storage Account の詳細情報
4. **接続** をクリック

### 2. ログの確認

データコネクタが正常に動作している場合、以下のクエリでログを確認できます：

```kql
LogsFromBlob_CL
| take 10
| project TimeGenerated, properties
```

## ログスキーマ

作成されるカスタムテーブル `LogsFromBlob_CL` のスキーマ (各種診断ログをストレージ アカウントに保存した場合のフォーマットを想定)：

| 列名 | 型 | 説明 |
|-----|----|----|
| `TimeGenerated` | datetime | ログの生成時刻 |
| `properties` | string | ログのプロパティ（JSON 形式） |

個別にカラムを設定の上で変換ルールを使用し、適切な形式に変換することも可能です。

