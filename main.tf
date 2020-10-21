# Configure the Azure Provider
terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"
			version = ">= 2.26"
		}
	}
}

provider "azurerm" {
	features {} # Required

	# Some tutorials say this is required, others don't?
        subscription_id = var.azure_subscription_id
        client_id       = var.azure_client_id
        client_secret   = var.azure_client_secret
        tenant_id       = var.azure_tenant_id
}

# Create the resource grouping required to 
# make the VMs
resource "azurerm_resource_group" "trg" {
	name = "TestResourceGroup"
	location = "westus2"
	
	tags = {
		Environment = "Terraform Tests!"
		Team = "DevOps"
	}
}

