# Run-MDEAIR
Sentinel インシデントにホスト エンティティが含まれる場合、MDE の自動調査機能を実行し、脅威がない場合、インシデントをクローズするプレイブックです。  
This is a playbook for executing the automated investigation feature of Microsoft Defender for Endpoint (MDE) when a Sentinel incident includes a host entity, and closing the incident if no threats are found.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fkatsato-ms%2FMicrosoft%2Fmain%2FLogic%2520Apps%2FRun-MDEAIR%2Fazuredeploy.json)
[![Deploy to Azure Gov](https://aka.ms/deploytoazuregovbutton)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fkatsato-ms%2FMicrosoft%2Fmain%2FLogic%2520Apps%2FRun-MDEAIR%2Fazuredeploy.json)
  
デプロイ後、Sentinel、MDE (Defender ATP) の API 接続を更新する必要があります。  
After deployment, you need to update the API connections for Sentinel, and MDE.
