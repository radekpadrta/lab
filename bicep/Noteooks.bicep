param machineLearningServiceName string 
param userAssignedIdentityName string
param storageAccountName string
param location string

// Change the URL below with that of your notebook
var urlNotebook= 'https://www.test.com/notebook.ipynp'

var dataStoreName = 'workspaceworkingdirectory' // Note: name auto-created by ML Workspace, DO NOT CHANGE
var azCliVersion = '2.47.0'

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: userAssignedIdentityName
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountName
}

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'notebooksUploadScript'
  location: location
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
        '${userAssignedIdentity.id}': {}
    }
  }
  properties: {
    azCliVersion: azCliVersion
    environmentVariables: [
      {
        name: 'URL_NOTEBOOK'
        value: urlNotebook
      }
      {
        name: 'MACHINE_LEARNING_SERVICE_NAME'
        value: machineLearningServiceName
      }
      {
        name: 'RESOURCE_GROUP_NAME'
        value: resourceGroup().name
      }
      {
        name: 'DATASTORE_NAME'
        value: dataStoreName
      }
      {
        name: 'AZURE_STORAGE_ACCOUNT'
        value: storageAccount.name
      }
      {
        name: 'AZURE_STORAGE_KEY'
        secureValue: storageAccount.listKeys().keys[0].value
      }
    ]
    scriptContent: loadTextContent('uploadNotebooks.script.sh')
    retentionInterval: 'P1D'
    cleanupPreference: 'Always'
    timeout: 'PT1H'
    forceUpdateTag: 'v1'
  }
}
