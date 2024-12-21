variable "env_id" {
  type        = string
  description = "The environment id"
  default     = "dev"
}

variable "subscription_id" {
  type        = string
  description = "The Azure subscription id"
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "source_key" {
  type        = string
  description = "The infastructure source"
  default     = "terraform"
}

variable "sql_pass" {
  type        = string
  description = "The SQL Server password"
  # no default means it will need to be an input
}

variable "sql_user" {
  type        = string
  description = "The SQL Server user"
  # no default means it will need to be an input
}
