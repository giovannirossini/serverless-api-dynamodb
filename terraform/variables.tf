variable "name" {
  description = "Name for resources"
  type        = string
  default     = "stage"
}

variable "acl" {
  description = "Access control list"
  type        = string
  default     = "private"
}

variable "cidr_block" {
  description = "CIDR block"
  type        = string
  default     = "110.0.0.0/16"
}

variable "email_notification" {
  description = "Email notification"
  type        = string
  default     = "giovannijrrossini@gmail.com"
}
