# Azure Cache for Redis with Non-SSL Port Enabled
# Azure Cache for Redis with public network access
# Azure Cache for Redis without Private Endpoint
# Azure Cache for Redis without TLS 1.2 or greater
# Azure Cache for Redis without Tags
# Azure Cache for Redis without mandatory Tags

# Enables non-SSL port.
# Does not set any Private Endpoint.
# Lacks any tags or mandatory tags configuration.
# By default, Azure Cache for Redis does allow public network access, and doesn't have a direct toggle for TLS versions less than 1.2. Azure recommends using the SSL port to ensure secure connections.


provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}

resource "azurerm_redis_cache" "example" {
  name                = "example-redis"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  capacity            = 1
  family              = "P"  # Premium tier
  sku_name            = "Premium"
  enable_non_ssl_port = false
  shard_count         = 1

  redis_configuration {
    rdb_backup_enabled            = true
    rdb_backup_frequency          = 60
    rdb_backup_max_snapshot_count = 1
    rdb_storage_connection_string = azurerm_storage_account.example.primary_blob_connection_string
    # aof_backup_enabled            = true
    # aof_storage_connection_string = azurerm_storage_account.example.primary_blob_connection_string
    # aof_backup_load_size          = "25mb"
  }

  public_network_access_enabled = false
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestoracc"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_monitor_diagnostic_setting" "example" {
  name               = "example-diagnostics"
  target_resource_id = azurerm_redis_cache.example.id
  storage_account_id = azurerm_storage_account.example.id

  log {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 7
    }
  }
}

