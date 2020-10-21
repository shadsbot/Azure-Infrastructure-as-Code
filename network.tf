###############################################
# Create a virtual network to apply to the RG #
###############################################
resource "azurerm_virtual_network" "vnet" {
        name                    = "TRG_VNet"
        address_space           = ["10.0.0.0/16"]
        location                = "westus2"
        resource_group_name     = azurerm_resource_group.trg.name
}

resource "azurerm_subnet" "snet" {
        name                    = "TRG_Subnet_1"
        resource_group_name     = azurerm_resource_group.trg.name
        virtual_network_name    = azurerm_virtual_network.vnet.name
        address_prefixes        = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "publicIP" {
        name                    = "PublicIP"
        location                = "westus2"
        resource_group_name     = azurerm_resource_group.trg.name
        allocation_method       = "Static"
}

resource "azurerm_network_security_group" "nsg" {
        name                    = "TRG_NetSec_Group_1"
        location                = "westus2"
        resource_group_name     = azurerm_resource_group.trg.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
	name			= "Allow_SSH"
	priority		= 1002
	resource_group_name	= azurerm_resource_group.trg.name
	
	network_security_group_name = azurerm_network_security_group.nsg.name

	access = "Allow"
	direction = "Inbound"
	protocol = "Tcp"
	source_port_range = "*"
	destination_port_range = "22"
	source_address_prefix = "*"
	destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "allow_web_traffic_encrypted" {
	name			= "Allow_Web_encrypted"
	priority		= 1000 
	resource_group_name	= azurerm_resource_group.trg.name
	
	network_security_group_name = azurerm_network_security_group.nsg.name

	access = "Allow"
	direction = "Inbound"
	protocol = "Tcp"
	source_port_range = "*"
	destination_port_range = "443"
	source_address_prefix = "*"
	destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "allow_web_traffic_unencrypted" {
	name			= "Allow_Web_Unencrypted"
	priority		= 1003
	resource_group_name	= azurerm_resource_group.trg.name
	
	network_security_group_name = azurerm_network_security_group.nsg.name

	access = "Allow"
	direction = "Inbound"
	protocol = "Tcp"
	source_port_range = "*"
	destination_port_range = "80"
	source_address_prefix = "*"
	destination_address_prefix = "*"
}

# NIC iface
resource "azurerm_network_interface" "eth0" {
        name                    = "eth0"
        location                = "westus2"
        resource_group_name     = azurerm_resource_group.trg.name

        ip_configuration {
                name                            = "eth0Conf"
                subnet_id                       = azurerm_subnet.snet.id
                private_ip_address_allocation   = "dynamic"
                public_ip_address_id            = azurerm_public_ip.publicIP.id
        }
}
