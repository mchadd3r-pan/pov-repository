# Azure Cosmos DB Customer-Managed Keys encryption is disabled
# Azure Cosmos DB without Automatic Failover
# Azure Cosmos DB with unrestricted network access
# Azure Cosmos DB without Advanced Threat Protection
# Azure Cosmos DB without built-in Backup and Recovery service
# Azure Cosmos DB without mandatory Tags


# It does not enable Customer-Managed Keys encryption (the default behavior).

# It enables public network access (unrestricted).
# It lacks any configurations related to mandatory tags or Advanced Threat Protection. Advanced Threat Protection would be managed through Azure's Security Center and is not a property that you can set directly on the Cosmos DB account resource in Terraform.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_cosmosdb_account" "example" {
  name                = "example-cosmosdb"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  
  # Disable Automatic Failover (overrides default behavior).
  enable_automatic_failover = false
  
  # Azure Cosmos DB Customer-Managed Keys encryption is disabled (default behavior)
  # Azure Cosmos DB without Automatic Failover (default behavior)
  
  capabilities {
    name = "EnableCassandra"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }
  
  # Azure Cosmos DB with unrestricted network access
  public_network_access_enabled = true
  
  geo_location {
    location          = azurerm_resource_group.example.location
    failover_priority = 0
  }

  tags = {
    Owner = "Bob"
    BillTo = "Also Bob"
    CreatedBy = "Definitely still Bob"
    ProvisioningTeam = "Still Bob"
    ProductOwner = "Surpisingly, Bob"
    Classification = "Entirely PII"
    EndDate = "Tomorrow"
    Purpose = "Storing sensitive data"
    SubPurpose = "Storing the most sensitive data"
    EnvironmentName = "Development"
    SubEnvironmentName = "Still Development"
    DateCreated = "Yesterday"
    ProjectCode = "PrismaCloudRulez"
  }

  # No settings for mandatory Tags or Advanced Threat Protection
  # The built-in Backup and Recovery service is enabled by default and cannot be turned off in Cosmos DB
}

# Remember to setup Network Rules if needed. The default is unrestricted access.

