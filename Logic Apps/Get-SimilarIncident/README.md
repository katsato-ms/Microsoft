# Send Billing Summary
この Logic Apps テンプレートを使用して、類似の過去インシデントの対応状況をコメントから確認し、Azure OpenAI で分析、過検知を判断することができます。  
You can use this Logic Apps template to review the response status of similar past incidents from comments, analyze them with Azure OpenAI, and determine falsepositive.


[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fkatsato-ms%2FMicrosoft%2Fmain%2FLogic%2520Apps%2FSend-BillingSummary%2Fazuredeploy.json)
[![Deploy to Azure Gov](https://aka.ms/deploytoazuregovbutton)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fkatsato-ms%2FMicrosoft%2Fmain%2FLogic%2520Apps%2FSend-BillingSummary%2Fazuredeploy.json)

デプロイ後、Azure Monitor、Sentinel、Azure OpenAI の API 接続を更新する必要があります。
After deployment, you need to update the API connections for Azure Monitor, Sentinel, and Azure OpenAI. 

