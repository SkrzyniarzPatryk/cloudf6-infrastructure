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

#######################################
# Database
#######################################
variable "db_name" {
  type    = string
  default = "javaserviceapppsqlflexserver"
}

variable "postgres_version" {
  type    = number
  default = 16
}

variable "storage_mb" {
  type    = number
  default = 32768
}

variable "storage_tier" {
  type    = string
  default = "P4"
}

variable "sku_name" {
  type    = string
  default = "B_Standard_B1ms"
}

variable "zone" {
  type    = string
  default = "3"
}

# DB access
variable "login" {
  type = string
}
variable "password" {
  type = string
}
#^

# DB public access
# but probably need change dns 
variable "public_access" {
  type    = bool
  default = false
}
variable "subnet_id" {
  type = string
}
variable "vnet_id" {
  type = string
}
#^

#######################################
# Database count
#######################################
variable "databases_list" {
  type    = list(string)
  default = ["payments"]
}