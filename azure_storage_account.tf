provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West US"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestoracc"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  sftp_enabled             = true

  routing {
    choice = "publish_internet_endpoints"
  }

  share_properties {
    smb {
      versions = "SMB3.1.1"
      channel_encryption_type = "AES-256-GCM"
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_encryption_scope" "example" {
  name                   = "encryption-scope"
  storage_account_id     = azurerm_storage_account.example.id
  source                 = "Microsoft.KeyVault"
  key_vault_key_id       = azurerm_key_vault_key.example.id
}
