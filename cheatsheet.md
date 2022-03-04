Create whole cluster including ressource group
https://trstringer.com/create-aks-bicep/

Create Ressource group
az group create --name RateMyBeer --location westeurope

Plan
az deployment group validate --template-file main.bicep --resource-group RateMyBeer
az deployment group create --template-file main.bicep --resource-group RateMyBeer --what-if    

Apply
az deployment group create --template-file main.bicep --resource-group RateMyBeer


Subscription root scope

az deployment sub create --template-file ./main.bicep --location westeurope