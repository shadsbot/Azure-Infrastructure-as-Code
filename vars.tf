# Project Specific Vars
variable "admin_username" {
        type = string
        description = "Administrator username"
}

variable "admin_password" {
        type = string
        description = "Password must meet Azure complexity requirements"
}

variable "staging" {
        type = bool
        description = "True: Staging Server, not available to public\nFalse: Production server, handle with care."
}


# Azure authentication variables
variable "azure_subscription_id" {
	type = string
	description = "Azure Subscription ID"
}

variable "azure_client_id" {
	type = string
	description = "Azure Client ID"
}

variable "azure_client_secret" {
	type = string
	description = "Azure Client Secret"
}

variable "azure_tenant_id" {
	type = string
	description = "Azure Tenant ID"
}
