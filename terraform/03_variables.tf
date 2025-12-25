########################
# General
########################
variable "location" {
  type    = string
  default = "westeurope"
}

variable "project_name" {
  type    = string
  default = "javaservices"
}

variable "common_tags" {
  type = map(any)
  default = {
    owner         = "patryk",
    project       = "javaapplication",
    working_since = "15.12.2025"
  }
}

########################
# Agic settings
########################
variable "agic_enabled" {
  type    = bool
  default = true
}

########################
# AKS
########################
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