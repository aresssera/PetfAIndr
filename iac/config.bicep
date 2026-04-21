@description('Name of the AKS cluster.')
param clusterName string = 'petfaindraks'

@description('Azure Storage Account name')
param storageAccountName string = 'storepetfaindr'

@description('Azure CosmosDB account name')
param cosmosAccountName string = 'cospetfaindr'

@description('Azure Service Bus authorization rule name')
param serviceBusAuthorizationRuleName string = 'buspetfaindr/Dapr'

@description('Custom Vision API training endpoint')
@secure()
param cvapiTrainingEndpoint string

@description('Custom Vision API training key')
@secure()
param cvapiTrainingKey string

@description('Custom Vision API prediction endpoint')
@secure()
param cvapiPredictionEndpoint string

@description('Custom Vision API prediction key')
@secure()
param cvapiPredictionKey string

@description('Custom Vision API project id')
@secure()
param cvapiProjectId string

@description('Custom Vision API prediction resource id')
@secure()
param cvapiPredictionResourceId string

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
    cvapiTrainingEndpoint: cvapiTrainingEndpoint
    cvapiTrainingKey: cvapiTrainingKey
    cvapiPredictionEndpoint: cvapiPredictionEndpoint
    cvapiPredictionKey: cvapiPredictionKey
    cvapiProjectId: cvapiProjectId
    cvapiPredictionResourceId: cvapiPredictionResourceId
  }
}
