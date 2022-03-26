
provider "azurerm" {
  # subscription_id = "${var.subscription_id}"
  # client_id       = "${var.client_id}"
  # client_secret   = "${var.client_secret}"
  # tenant_id       = "${var.tenant_id}"
  features {}
}

resource "azurerm_resource_group" "rg1" {
  name     = "${var.projectPrefix}-f5-xc1"
  location = var.azureRegion1
}


resource "azurerm_network_security_group" "f5-xc-nsg1" {
  name                = "f5_xc_nsg1"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = var.azureRegion1
}


resource "azurerm_network_security_rule" "f5-xc-nsg-rule1" {
  name                        = "allow_trusted1_1"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix      = var.trusted_ip
  #source_address_prefixes     = local.trusted_cidr
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.f5-xc-nsg1.name
}

resource "azurerm_network_security_rule" "f5-xc-nsg-rule1_2" {
  name                        = "allow_trusted1_2"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/8"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.f5-xc-nsg1.name
}


resource "azurerm_network_security_rule" "block_dns1_1" {
  name                        = "block_dns1_1"
  priority                    = 150
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.f5-xc-nsg1.name
}

resource "azurerm_network_security_rule" "allow_dns1_2" {
  name                        = "allow_dns1_2"
  priority                    = 149
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "10.0.0.0/8"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.f5-xc-nsg1.name
}

resource "azurerm_network_security_rule" "allow_dns1_3" {
  name                        = "allow_dns1_3"
  priority                    = 148
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "100.64.0.0/10"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.f5-xc-nsg1.name
}

resource "azurerm_virtual_network" "f5-xc-hub1" {
  name                = "f5_xc_hub_vnet1"
  location            = var.azureRegion1
  address_space       = [var.servicesVnetAddressSpace1]
  resource_group_name = azurerm_resource_group.rg1.name
}


resource "azurerm_subnet" "external1" {
  name                 = "external_subnet1"
  virtual_network_name = azurerm_virtual_network.f5-xc-hub1.name
  resource_group_name  = azurerm_resource_group.rg1.name
  address_prefixes     = [var.servicesVnetExternalSubnet1]
}

resource "azurerm_subnet" "internal1" {
  name                 = "internal_subnet1"
  virtual_network_name = azurerm_virtual_network.f5-xc-hub1.name
  resource_group_name  = azurerm_resource_group.rg1.name
  address_prefixes     = [var.servicesVnetInternalSubnet1]
}

resource "azurerm_subnet" "workload1" {
  name                 = "workload_subnet1"
  virtual_network_name = azurerm_virtual_network.f5-xc-hub1.name
  resource_group_name  = azurerm_resource_group.rg1.name
  address_prefixes     = [var.servicesVnetWorkloadSubnet1]
}

resource "azurerm_route_table" "workload1" {
  name                = "workload_rt1"
  location            = var.azureRegion1
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_subnet_route_table_association" "workload1" {
  subnet_id      = azurerm_subnet.workload1.id
  route_table_id = azurerm_route_table.workload1.id
}

resource "azurerm_subnet_network_security_group_association" "f5-xc1" {
  subnet_id                 = azurerm_subnet.external1.id
  network_security_group_id = azurerm_network_security_group.f5-xc-nsg1.id
}
