## Create Resource group by Bicep

First experience with Bicep, using VSCode extension

az bicep install  
az login
az deployment sub create --name Azuresubscription1 --location francecentral --template-file main.bicep --parameters dev.bicepparam 
