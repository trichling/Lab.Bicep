targetScope = 'subscription'

param location string = 'westeurope'
param resourceNameSuffix string = '12345'

var resourceGroupName = 'RateMyBeer${resourceNameSuffix}'

resource rateMyBeerResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module rateMyBeerCluster './cluster.bicep' = {
  name: 'ratemybeercluster${resourceNameSuffix}'
  scope: rateMyBeerResourceGroup
  params: {
    ressourceNameSuffix: resourceNameSuffix
    ressourceGroupLocation: rateMyBeerResourceGroup.location
  }
}
