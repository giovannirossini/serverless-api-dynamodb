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
