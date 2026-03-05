variable "resource_group_name" {
  type        = string
  description = "ressource group name value"
}

variable "location" {
  type        = string
  description = "location value"
}
variable "tags" {
  type = map(string)
}