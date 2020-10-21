####################
# Virtual Machines #
####################
resource "azurerm_linux_virtual_machine" "vm1" {
        name                    = "SuperCoolVM"
        location                = "westus2"
        resource_group_name     = azurerm_resource_group.trg.name
        network_interface_ids   = [azurerm_network_interface.eth0.id]
        size	                = "Standard_DS1_v2"     # I guess this corresponds to
                                                        # whatever their plans are called?

        disable_password_authentication = false # should really just be using an RSA key
	admin_username		= var.admin_username
	admin_password		= var.admin_password

        os_disk {
                name                    = "One_ColdBoi"
                caching                 = "ReadWrite"
                storage_account_type	= "Premium_LRS" # And this as well?
        }

        source_image_reference {
                publisher = "Canonical"
                offer = "UbuntuServer"
                sku = "18.04-LTS"
                version = "latest"
        }

	provisioner "remote-exec" {
		inline = [
			"sudo apt-get -y update",
			"sudo apt-get -y install nginx",
		]

		connection {
			host		= self.public_ip_address
			user		= self.admin_username
			password	= self.admin_password
		}
	}
}

data "azurerm_public_ip" "ip" {
        name                    = azurerm_public_ip.publicIP.name
        resource_group_name     = azurerm_linux_virtual_machine.vm1.resource_group_name
        depends_on              = [azurerm_linux_virtual_machine.vm1]
}

