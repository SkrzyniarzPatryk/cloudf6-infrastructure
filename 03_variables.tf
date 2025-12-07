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
    working_since = "07.12.2025"
  }
}