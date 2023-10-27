import radius as radius

@description('The ID of your Radius Environment. Automatically injected by the rad CLI.')
param environment string

@description('The ID of your Radius Application. Automatically injected by the rad CLI.')
param application string


resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/tutorial/webapp:edge'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
  }
}

resource db 'Applications.Datastores/sqlDatabases@2023-10-01-preview' = {
  name: 'db2'
  properties: {
    environment: environment
    application: application
    recipe: {
      name: 'mymssql'
    } 
  }
}
