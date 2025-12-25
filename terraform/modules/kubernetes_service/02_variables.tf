variable "project_prefix" {
  type        = string
  default     = "project"
  description = "Prefix for resource names"
}

variable "location" {
  default     = ""
  description = "Location of resources"
}

variable "resource_group_name" {
  type        = string
  default     = ""
  description = "Resource group name"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags"
}

####################################################
# Subnets
####################################################
variable "appgw_subnet_id" {
  type = string
}

variable "aks_node_subnet_id" {
  type = string
}

####################################################
# Application Gateway Ingress Controller (AGIC) settings
####################################################
variable "agic_enabled" {
  type    = bool
  default = true
}

####################################################
# ACR settings
####################################################
variable "acr_id" {
  type = string
}

####################################################
# Default node pool settings
####################################################
variable "aks_node_count" {
  type    = number
  default = 1
}

variable "aks_vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "aks_auto_scaling_enabled" {
  type    = bool
  default = true

}
variable "aks_min_count" {
  type    = number
  default = 1
}

variable "aks_max_count" {
  type    = number
  default = 2
}

variable "aks_temporary_name_for_rotation" {
  type    = string
  default = "akstemporar"
}