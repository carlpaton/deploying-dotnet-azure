variable "env_id" {
  type        = string
  description = "The environment id"
  default     = "dev"
}

variable "source_key" {
  type        = string
  description = "The infastructure source"
  default     = "terraform"
}

variable "location" {
  type        = string
  description = "The Azure resources location"
  default     = "Australia East"
}

variable "subscription_id" {
  type        = string
  description = "The Azure subscription id"
}

variable "sql_pass" {
  type        = string
  description = "The SQL Server password"
}

variable "sql_user" {
  type        = string
  description = "The SQL Server user"
}

variable "group_key" {
  type        = string
  description = "Some Azure resources need to be unique, while testing its helpful to use the start of a GUID. Mostly redundant for Porduction as everything is in a resource group."
  default     = "bb8c7a39"
}
