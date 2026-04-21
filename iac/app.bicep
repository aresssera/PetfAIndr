// Application -----------------------------------------

@description('Name of the container registry.')
param registryName string = 'petfaindr6acr'

@description('Name of the AKS cluster.')
param clusterName string = 'petfaindraks'

@description('Container image tag to deploy (e.g. sha-abc1234 or latest).')
param containerTag string = 'latest'

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' existing = {
  name: registryName
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-08-01' existing = {
  name: clusterName
}

module frontend 'app/frontend.bicep' = {
  name: 'frontend'
  params: {
    containerRegistry: containerRegistry.properties.loginServer
    kubeConfig: aksCluster.listClusterAdminCredential().kubeconfigs[0].value
    containerTag: containerTag
  }
}

module backend 'app/backend.bicep' = {
  name: 'backend'
  params: {
    containerRegistry: containerRegistry.properties.loginServer
    kubeConfig: aksCluster.listClusterAdminCredential().kubeconfigs[0].value
    containerTag: containerTag
  }
}

//module ingress 'app/ingress.bicep' = {
//  name: 'ingress'
//  params: {
//    kubeConfig: aksCluster.listClusterAdminCredential().kubeconfigs[0].value
//  }
//}
