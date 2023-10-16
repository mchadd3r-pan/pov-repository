# AD System-assigned Identity is not assigned to App Azure Service
# AD User-assigned Identity is not assigned to Azure App Service
# Azure App Service access from public network
# Azure App Service does not require HTTPS
# Azure App Service running outdated Java version
# Azure App Service running outdated PHP version
# Azure App Service running outdated Python version
# Azure App Service with CORS configured
# Azure App Service with Remote Debugging enabled
# Azure App Service with insecure FTP deployment enabled
# Azure App Service with outdated TLS
# Azure App Service with outdated version of HTTP
# Azure App Service without Virtual Network
# Azure App Service without client certification
# Azure App Service without mandatory Tags
# Azure App Service without private endpoint connection
# Azure App Service without routing to Azure Virtual Network
# Microsoft Defender for App Service is disabled

# This configuration:

# Sets up an outdated version of Java, PHP, and Python.
# Configures CORS.
# Enables remote debugging.
# Allows insecure FTP deployment.
# Uses an outdated TLS version.
# Doesn't set any system-assigned or user-assigned identity.
# Lacks configurations related to Virtual Networks, client certification, private endpoint connections, etc.
# However, some of the attributes you mentioned aren't directly controllable via Terraform or aren't relevant. For instance:

# "Azure App Service access from public network" - This is the default behavior of App Service; no special configuration is needed.
# "Azure App Service does not require HTTPS" - App Service supports both HTTP and HTTPS by default.
# "Azure App Service with outdated version of HTTP" - The HTTP version isn't something you typically set on App Service; it's dependent on the underlying platform.

provider "azurerm" {
  features {}
}

resource "azurerm_app_service_plan" "example" {
  name                = "example-asp"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "Linux"

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "example" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id
  
  # Assuming the application type here. You would need to specify the appropriate runtime
  site_config {
    dotnet_framework_version = "v4.0" # Just an example. Change according to needs.
    java_version             = "1.7"  # Outdated version as an example
    python_version           = "3.4"  # Outdated version as an example
    php_version              = "5.6"  # Outdated version as an example
    
    cors {
      allowed_origins     = ["http://www.example.com"]
      support_credentials = false
    }
    
    remote_debugging_enabled = true
    ftps_state               = "AllAllowed" # Insecure FTP deployment
    
    min_tls_version = "1.1" # Outdated TLS

    always_on        = true
    use_32_bit_worker_process = true
  }
  
  # Note: Leaving out identity configuration as system-assigned and user-assigned identities are not wanted
  
  tags = {
    # No mandatory tags
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }
}

