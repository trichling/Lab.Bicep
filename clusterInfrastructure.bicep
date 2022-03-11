param dnsLabel string
param location string

resource rateMyBeerClusterPublicIp 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: 'KubernetesNginxIngressPuplicIp'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: dnsLabel 
    }
  }
}
