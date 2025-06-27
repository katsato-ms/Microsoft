# Check-FalsePositiveByAI
この Logic Apps テンプレートは、Sentinel インシデントのエンティティ情報を活用し、Azure OpenAI を使って指定された条件に一致するかどうかを確認し、その結果に基づいてインシデントを更新します。
This Logic Apps template utilizes entity information from Sentinel incidents, checks whether it meets specified conditions using Azure OpenAI, and updates the incident based on the results.
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fkatsato-ms%2FMicrosoft%2Fmain%2FLogic%2520Apps%2FCheck-FalsePositiveByAI%2Fazuredeploy.json)
[![Deploy to Azure Gov](https://aka.ms/deploytoazuregovbutton)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fkatsato-ms%2FMicrosoft%2Fmain%2FLogic%2520Apps%2FCheck-FalsePositiveByAI%2Fazuredeploy.json)

デプロイ後、Azure OpenAI と ip2location の API 接続を更新する必要があります。  
After deployment, you need to update the API connections for Azure OpenAI and ip2location. 
