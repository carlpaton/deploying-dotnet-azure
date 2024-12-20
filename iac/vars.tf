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
