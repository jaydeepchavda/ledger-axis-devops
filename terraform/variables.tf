variable "aws_region" {
  description = "AWS region for the infrastructure"
  type        = string
  default     = "ap-south-1"
}

variable "domain_name" {
  description = "Root domain managed by Route 53"
  type        = string
}