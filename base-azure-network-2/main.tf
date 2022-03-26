
provider "azurerm" {
  # subscription_id = "${var.subscription_id}"
  # client_id       = "${var.client_id}"
  # client_secret   = "${var.client_secret}"
  # tenant_id       = "${var.tenant_id}"
  features {}
}

resource "azurerm_resource_group" "rg2" {
  name     = "${var.projectPrefix}-f5-xc2"
  location = var.azureRegion2
}


resource "azurerm_network_security_group" "f5-xc-nsg2" {
  name                = "f5_xc_nsg2"
  resource_group_name = azurerm_resource_group.rg2.name
  location            = var.azureRegion2
}


resource "azurerm_network_security_rule" "f5-xc-nsg-rule2_1" {
  name                        = "allow_trusted2_1"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix      = var.trusted_ip
  #source_address_prefixes     = local.trusted_cidr
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg2.name
  network_security_group_name = azurerm_network_security_group.f5-xc-nsg2.name
}

resource "azurerm_network_security_rule" "f5-xc-nsg-rule2_2" {
  name                        = "allow_trusted2_2"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/8"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg2.name
  network_security_group_name = azurerm_network_security_group.f5-xc-nsg2.name
}


resource "azurerm_network_security_rule" "block_dns2_1" {
  name                        = "block_dns2_1"
  priority                    = 150
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg2.name
  network_security_group_name = azurerm_network_security_group.f5-xc-nsg2.name
}

resource "azurerm_network_security_rule" "allow_dns2_2" {
  name                        = "allow_dns"
  priority                    = 149
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "10.0.0.0/8"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg2.name
  network_security_group_name = azurerm_network_security_group.f5-xc-nsg2.name
}

resource "azurerm_network_security_rule" "allow_dns2_3" {
  name                        = "allow_dns2_3"
  priority                    = 148
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "100.64.0.0/10"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg2.name
  network_security_group_name = azurerm_network_security_group.f5-xc-nsg2.name
}



resource "azurerm_virtual_network" "f5-xc-hub2" {
  name                = "f5_xc_hub_vnet2"
  location            = var.azureRegion2
  address_space       = [var.servicesVnetAddressSpace2]
  resource_group_name = azurerm_resource_group.rg2.name
}


resource "azurerm_subnet" "external2" {
  name                 = "external_subnet2"
  virtual_network_name = azurerm_virtual_network.f5-xc-hub2.name
  resource_group_name  = azurerm_resource_group.rg2.name
  address_prefixes     = [var.servicesVnetExternalSubnet2]
}

resource "azurerm_subnet" "internal2" {
  name                 = "internal_subnet2"
  virtual_network_name = azurerm_virtual_network.f5-xc-hub2.name
  resource_group_name  = azurerm_resource_group.rg2.name
  address_prefixes     = [var.servicesVnetInternalSubnet2]
}

resource "azurerm_subnet" "workload2" {
  name                 = "workload_subnet2"
  virtual_network_name = azurerm_virtual_network.f5-xc-hub2.name
  resource_group_name  = azurerm_resource_group.rg2.name
  address_prefixes     = [var.servicesVnetWorkloadSubnet2]
}

resource "azurerm_subnet" "gateway2" {
  name                 = "GatewaySubnet2"
  virtual_network_name = azurerm_virtual_network.f5-xc-hub2.name
  resource_group_name  = azurerm_resource_group.rg2.name
  address_prefixes     = [var.servicesVnetGatewaySubnet2]
}

resource "azurerm_route_table" "workload2" {
  name                = "workload_rt2"
  location            = var.azureRegion2
  resource_group_name = azurerm_resource_group.rg2.name
}

resource "azurerm_subnet_route_table_association" "workload2" {
  subnet_id      = azurerm_subnet.workload2.id
  route_table_id = azurerm_route_table.workload2.id
}

resource "azurerm_subnet_network_security_group_association" "f5-xc2" {
  subnet_id                 = azurerm_subnet.external2.id
  network_security_group_id = azurerm_network_security_group.f5-xc-nsg2.id
}
