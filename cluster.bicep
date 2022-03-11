param ressourceNameSuffix string
param ressourceGroupLocation string = resourceGroup().location
param ressourceGroupName string = resourceGroup().name

param clusterNodeCount int = 1
param clusterNodeVMSize string = 'Standard_B2s'
param clusterName string = 'ratemybeer${ressourceNameSuffix}'

var rateMyBeerMCRessourceGroupName = 'MC_${ressourceGroupName}_${clusterName}_${ressourceGroupLocation}'

resource rateMyBeerContainerRegistry 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name: 'ratemybeercontaierregisty${ressourceNameSuffix}'
  location: ressourceGroupLocation
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: false
  }
}

resource rateMyBeerCluster 'Microsoft.ContainerService/managedClusters@2021-03-01' = {
  name: clusterName
  location: ressourceGroupLocation

  identity: {
    type: 'SystemAssigned'
  }

  properties: {
    dnsPrefix: clusterName
    enableRBAC: true
    
    agentPoolProfiles: [
      {
        name: 'default'
        count: clusterNodeCount
        vmSize: clusterNodeVMSize
        mode: 'System'
      }
    ]
  }
}

module clusterInfrastructure 'clusterInfrastructure.bicep' = {
  name: 'deployClusterInfrastructure'
  scope: resourceGroup(rateMyBeerMCRessourceGroupName)
  dependsOn:[
    rateMyBeerCluster
  ]
  params:{
    dnsLabel: clusterName
    location: ressourceGroupLocation
  }
}

// https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
@description('This is the built-in Contributor role. See https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#contributor')
resource AcrPullRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: '7f951dda-4ed3-4680-a7ca-43fe172d538d'
}

// https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/scenarios-rbac
resource AssignAcrPullToAks  'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid(rateMyBeerContainerRegistry.id, rateMyBeerCluster.id, 'acrPullRole')
  scope: rateMyBeerContainerRegistry // extension ressource
  properties: {
    // https://github.com/Azure/bicep/discussions/3181
    principalId: rateMyBeerCluster.properties.identityProfile.kubeletidentity.objectId
    roleDefinitionId: AcrPullRoleDefinition.id
  }
}
