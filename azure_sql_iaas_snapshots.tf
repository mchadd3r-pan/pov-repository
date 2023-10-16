provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West US"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "example-publicip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_mssql_virtual_machine" "example" {
  virtual_machine_id   = azurerm_virtual_machine.example.id
  sql_license_type     = "PAYG"
  r_services_enabled   = false

  # The following example uses the default SQL Server settings; adjust as needed
  sql_connectivity_type               = "PUBLIC"
  sql_connectivity_port               = 1433
  sql_connectivity_update_password    = "Password123!"
  sql_connectivity_update_username    = "adminuser"
}

resource "azurerm_virtual_machine" "example" {
  name                  = "example-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = "Standard_F2"

  storage_image_reference {
    id = "YOUR_SNAPSHOT_ID"  # Replace with your disk snapshot ID
  }

  storage_os_disk {
    name              = "osdisk-example"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    os_type           = "Windows"  # Adjust based on your snapshot OS type
    managed_disk_type = "Premium_LRS"  # This line specifies the use of Premium Storage
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_windows_config {}
}

# Include any other necessary configurations like virtual machine availability set if needed.

