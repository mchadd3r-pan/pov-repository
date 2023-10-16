# Azure Container Registry with Active Directory ARM Enabled
# Azure Container Registry with Anonymous Pull enabled
# Azure Container Registry with Export Policy Enabled
# Azure Container Registry with Network Security Groups (NSG) allowing public access
# Azure Container Registry with Public Access
# Azure Container Registry with unrestricted network access

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_container_registry" "example" {
  name                     = "exampleacrregistry"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  sku                      = "Basic"
  admin_enabled            = true
  public_network_access_enabled = true
  
  identity {
    type = "SystemAssigned"
  }

  network_rule_set {
    default_action = "Allow"
  }

  georeplications {
    location                = "East US"
    zone_redundancy_enabled = true
    tags                    = {}
  }

  quarantine_policy_enabled = false
  trust_policy {
    type = "Notary"
  }

  retention_policy {
    days    = 7
    enabled = true
  }

  tags = {
    Owner = "Bob"
    BillTo = "Also Bob"
    Environment = "Development"
    ProjectCode = "PrismaCloudRulez"
  }
}

resource "azurerm_container_registry_scope_map" "example" {
  name                     = "exampleacrscopemap"
  container_registry_name  = azurerm_container_registry.example.name
  resource_group_name      = azurerm_resource_group.example.name
  description              = "All actions"
  
  actions                  = ["content/read", "content/write", "content/delete"]
}

resource "azurerm_container_registry_token" "example" {
  name                     = "exampleacrtoken"
  container_registry_name  = azurerm_container_registry.example.name
  resource_group_name      = azurerm_resource_group.example.name
  scope_map_id             = azurerm_container_registry_scope_map.example.id

  status                   = "enabled"
}

resource "azurerm_network_security_group" "example" {
  name                = "examplensg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "allow_all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "Canada Central"
}

resource "azurerm_container_registry" "example" {
  name                = "exampleContainerRegistry"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Basic"
  admin_enabled       = true

  # No dedicated Resource Group for ACR
  # No Encryption with CMK
  # No Zone Redundancy
  # No Private Endpoint
  # No access from Azure Services
}

# Ensure you also have a configured backend for storing state and any required variables.
