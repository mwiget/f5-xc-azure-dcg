#resource "azurerm_resource_group" "peering" {
#  name     = format("%s-peeredvnets", var.projectPrefix)
#  location = var.azureRegion1
#}

resource "azurerm_virtual_network_peering" "peering-1" {
  name                      = format("%s-peer1to2", var.projectPrefix)
  resource_group_name       = var.resourceGroup1
  virtual_network_name      = var.hubVnetName1
  remote_virtual_network_id = var.hubVnetId2
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "peering-2" {
  name                      = format("%s-peer2to1", var.projectPrefix)
  resource_group_name       = var.resourceGroup2
  virtual_network_name      = var.hubVnetName2
  remote_virtual_network_id = var.hubVnetId1
  allow_forwarded_traffic   = true
}
