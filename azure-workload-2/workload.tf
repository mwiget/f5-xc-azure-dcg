# Create public IPs
resource "azurerm_public_ip" "workload" {
  name                = "workload_pip"
  resource_group_name = var.resourceGroup
  location            = var.azureRegion2
  allocation_method   = "Dynamic"
}

# Create NIC
resource "azurerm_network_interface" "workload" {
  name                = "workload-nic"
  resource_group_name = var.resourceGroup
  location            = var.azureRegion2

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.workloadSubnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.workload.id
  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "workload" {
  name                = "workload"
  resource_group_name = var.resourceGroup
  location            = var.azureRegion2
  size                = "Standard_DS1_v2"

  network_interface_ids = [azurerm_network_interface.workload.id]

  os_disk {
    name                 = "workload"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "workload2"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  custom_data = filebase64("user-data.sh")

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }
}
