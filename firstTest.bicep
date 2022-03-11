param ressourceGroupLocation string = resourceGroup().location

resource rateMyBeerStorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'ratemybeerstorage'
  location: ressourceGroupLocation
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  tags:{
    kind: 'development'
    costCenter: '4711'
  }
}
