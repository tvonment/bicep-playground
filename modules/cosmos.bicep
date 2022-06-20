param cosmosDBAccountName string = 'toyrnd-${uniqueString(resourceGroup().id)}'
param location string = resourceGroup().location
param cosmosDBDatabaseThroughput int = 400
var cosmosDBDatabaseName = 'FlightTests'
var cosmosDBContainerName = 'FlightTests'
var cosmosDBContainerPartitionKey = '/droneId'

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2020-04-01' = {
  name: cosmosDBAccountName
  location: location
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
      }
    ]
  }
  resource cosmosDBDatabase 'sqlDatabases' = {
    name: cosmosDBDatabaseName
    properties: {
      resource: {
        id: cosmosDBDatabaseName
      }
      options: {
        throughput: cosmosDBDatabaseThroughput
      }
    }
    resource container 'containers' = {
      name: cosmosDBContainerName
      properties: {
        resource: {
          id: cosmosDBContainerName
          partitionKey: {
            kind: 'Hash'
            paths: [
              cosmosDBContainerPartitionKey
            ]
          }
        }
        options: {}
      }
    }
  }
}
@description('The name of the CosmosDB Account.')
output cosmosDBAccountName string = cosmosDBAccount.name
