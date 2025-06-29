variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
  default     = "rg-lb-vm-demo"
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = "East US"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}
variable "admin_username" {
  type        = string
  description = "Administrator username"
}

variable "admin_password" {
  type        = string
  description = "Administrator password"
  sensitive   = true
}
