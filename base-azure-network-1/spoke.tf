resource "azurerm_network_security_group" "f5-xc-spoke-nsg1" {
  name                = "f5_xc_spoke_nsg1"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = var.azureRegion1
}

resource "azurerm_network_security_rule" "f5-xc-spoke-nsg-rule1_1" {
  name                        = "allow_trusted_spoke1_1"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix      = var.trusted_ip
  #source_address_prefixes     = local.auto_trusted_cidr
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.f5-xc-spoke-nsg1.name
}

resource "azurerm_network_security_rule" "f5-xc-spoke-nsg-rule1_2" {
  name                        = "allow_trusted_spoke1_2"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "100.64.0.0/10"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.f5-xc-spoke-nsg1.name
}

resource "azurerm_network_security_rule" "f5-xc-spoke-nsg-rule1_3" {
  name                        = "allow_trusted_spoke1_3"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.2.0.0/16"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.f5-xc-spoke-nsg1.name
}

resource "azurerm_virtual_network" "f5-xc-spoke1" {
  name                = "f5_xc_spoke_vnet1"
  location            = var.azureRegion1
  address_space       = [var.spokeVnetAddressSpace1]
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_subnet" "external-spoke1" {
  name                 = "external_subnet1"
  virtual_network_name = azurerm_virtual_network.f5-xc-spoke1.name
  resource_group_name  = azurerm_resource_group.rg1.name
  address_prefixes     = [var.spokeVnetExternalSubnet1]
}

resource "azurerm_subnet" "internal-spoke1" {
  name                 = "internal_subnet1"
  virtual_network_name = azurerm_virtual_network.f5-xc-spoke1.name
  resource_group_name  = azurerm_resource_group.rg1.name
  address_prefixes     = [var.spokeVnetInternalSubnet1]
}

resource "azurerm_subnet" "workload-spoke1" {
  name                 = "workload_subnet1"
  virtual_network_name = azurerm_virtual_network.f5-xc-spoke1.name
  resource_group_name  = azurerm_resource_group.rg1.name
  address_prefixes     = [var.spokeVnetWorkloadSubnet1]
}

resource "azurerm_route_table" "workload-spoke1" {
  name                = "workload-spoke_rt1"
  location            = var.azureRegion1
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_subnet_route_table_association" "workload-spoke1" {
  subnet_id      = azurerm_subnet.workload-spoke1.id
  route_table_id = azurerm_route_table.workload-spoke1.id
}

resource "azurerm_subnet_network_security_group_association" "f5-xc-spoke1" {
  subnet_id                 = azurerm_subnet.external-spoke1.id
  network_security_group_id = azurerm_network_security_group.f5-xc-spoke-nsg1.id
}

resource "azurerm_virtual_network_peering" "toSpoke1" {
  name                      = "toSpoke1"
  resource_group_name       = azurerm_resource_group.rg1.name
  virtual_network_name      = azurerm_virtual_network.f5-xc-hub1.name
  remote_virtual_network_id = azurerm_virtual_network.f5-xc-spoke1.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "toHub1" {
  name                      = "toHub1"
  resource_group_name       = azurerm_resource_group.rg1.name
  virtual_network_name      = azurerm_virtual_network.f5-xc-spoke1.name
  remote_virtual_network_id = azurerm_virtual_network.f5-xc-hub1.id
  allow_forwarded_traffic   = true
}
