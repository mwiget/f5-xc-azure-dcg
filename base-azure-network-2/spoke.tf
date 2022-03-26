

resource "azurerm_network_security_group" "f5-xc-spoke-nsg2" {
  name                = "f5_xc_spoke_nsg2"
  resource_group_name = azurerm_resource_group.rg2.name
  location            = var.azureRegion2
}


resource "azurerm_network_security_rule" "f5-xc-spoke-nsg-rule2_1" {
  name                        = "allow_trusted_spoke2_1"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix      = var.trusted_ip
  #source_address_prefixes     = local.auto_trusted_cidr
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg2.name
  network_security_group_name = azurerm_network_security_group.f5-xc-spoke-nsg2.name
}

resource "azurerm_network_security_rule" "f5-xc-spoke-nsg-rule2_2" {
  name                        = "allow_trusted_spoke2_2"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "100.64.0.0/10"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg2.name
  network_security_group_name = azurerm_network_security_group.f5-xc-spoke-nsg2.name
}

resource "azurerm_network_security_rule" "f5-xc-spoke-nsg-rule2_3" {
  name                        = "allow_trusted_spoke2_3"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.2.0.0/16"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg2.name
  network_security_group_name = azurerm_network_security_group.f5-xc-spoke-nsg2.name
}


resource "azurerm_virtual_network" "f5-xc-spoke2" {
  name                = "f5_xc_spoke_vnet2"
  location            = var.azureRegion2
  address_space       = [var.spokeVnetAddressSpace2]
  resource_group_name = azurerm_resource_group.rg2.name
}


resource "azurerm_subnet" "external-spoke2" {
  name                 = "external_subnet"
  virtual_network_name = azurerm_virtual_network.f5-xc-spoke2.name
  resource_group_name  = azurerm_resource_group.rg2.name
  address_prefixes     = [var.spokeVnetExternalSubnet2]
}

resource "azurerm_subnet" "internal-spoke2" {
  name                 = "internal_subnet"
  virtual_network_name = azurerm_virtual_network.f5-xc-spoke2.name
  resource_group_name  = azurerm_resource_group.rg2.name
  address_prefixes     = [var.spokeVnetInternalSubnet2]
}

resource "azurerm_subnet" "workload-spoke2" {
  name                 = "workload_subnet"
  virtual_network_name = azurerm_virtual_network.f5-xc-spoke2.name
  resource_group_name  = azurerm_resource_group.rg2.name
  address_prefixes     = [var.spokeVnetWorkloadSubnet2]
}

resource "azurerm_route_table" "workload-spoke2" {
  name                = "workload-spoke_rt2"
  location            = var.azureRegion2
  resource_group_name = azurerm_resource_group.rg2.name
}

resource "azurerm_subnet_route_table_association" "workload-spoke2" {
  subnet_id      = azurerm_subnet.workload-spoke2.id
  route_table_id = azurerm_route_table.workload-spoke2.id
}

resource "azurerm_subnet_network_security_group_association" "f5-xc-spoke2" {
  subnet_id                 = azurerm_subnet.external-spoke2.id
  network_security_group_id = azurerm_network_security_group.f5-xc-spoke-nsg2.id
}

resource "azurerm_virtual_network_peering" "toSpoke2" {
  name                      = "toSpoke2"
  resource_group_name       = azurerm_resource_group.rg2.name
  virtual_network_name      = azurerm_virtual_network.f5-xc-hub2.name
  remote_virtual_network_id = azurerm_virtual_network.f5-xc-spoke2.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "toHub2" {
  name                      = "toHub2"
  resource_group_name       = azurerm_resource_group.rg2.name
  virtual_network_name      = azurerm_virtual_network.f5-xc-spoke2.name
  remote_virtual_network_id = azurerm_virtual_network.f5-xc-hub2.id
  allow_forwarded_traffic   = true
}
