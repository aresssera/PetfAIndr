@description('Name of the AKS cluster. Defaults to a unique hash prefixed with "petfaindr"')
param clusterName string = 'petfaindr'

@description('Azure Storage Account name')
param storageAccountName string = 'petfaindr${uniqueString(resourceGroup().id)}'

@description('Azure CosmosDB account name')
param cosmosAccountName string = 'petfaindr-${uniqueString(resourceGroup().id)}'

@description('Azure Service Bus authorization rule name')
param serviceBusAuthorizationRuleName string = 'petfaindr-${uniqueString(resourceGroup().id)}/Dapr'

resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-08-01' existing = {
  name: clusterName
}

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' existing = {
  name: cosmosAccountName
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: storageAccountName
}

resource serviceBusAuthorizationRule 'Microsoft.ServiceBus/namespaces/AuthorizationRules@2022-01-01-preview' existing = {
  name: serviceBusAuthorizationRuleName
}

module secrets 'secrets.bicep' = {
  name: 'secrets'
  params: {
    cosmosUrl: cosmosAccount.properties.documentEndpoint
    cosmosAccountKey: cosmosAccount.listKeys().primaryMasterKey
    kubeConfig: aksCluster.listClusterAdminCredential().kubeconfigs[0].value
    storageAccountName: storageAccount.name
    storageAccountKey: storageAccount.listKeys().keys[0].value
    serviceBusConnectionString: serviceBusAuthorizationRule.listKeys().primaryConnectionString
    cvapiTrainingEndpoint: '<your custom Vision API TRAINING endoint indcluding the last "/">'
    cvapiTrainingKey: '<your custom Vision API Training Key>'
    cvapiPredictionEndpoint: '<your custom Vision PREDICTION API endoint indcluding the last "/">'
    cvapiPredictionKey: '<your custom Vision API Prediction Key>'
    cvapiProjectId: ''<your custom Vision project ID>''
    cvapiPredictionResourceId: ''<your custom Vision Prediction Resource ID>''
  }
}
