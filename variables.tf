variable "region" {
  description = "The AWS region to use"
  default     = "eu-west-2"
  type        = string
}

variable "prefix" {
  description = "The environment prefix"
  type        = string
}

variable "azs" {
  description = "A list of Availabilty Zones"
  default     = ["eu-west-2a", "eu-west-2b"]
  type        = list(string)
}

variable "cluster_name" {
  description = "value of cluster name"
  type        = string
}

variable "capacity_provider" {
  description = "value of capacity provider"
  type        = list(string)
}

variable "default_capacity_provider" {
  description = "value of default capacity provider"
  type        = string
}

variable "container_insights_enabled" {
  description = "value of container insights enabled"
  type        = bool
}


variable "rds" {
  description = "Map of variables used to provision RDS instance"
  type        = map(string)
}

variable "rds_username" {
  description = "Map of variables used to provision RDS instance"
  type        = string
}

variable "rds_password" {
  description = "Map of variables used to provision RDS instance"
  type        = string
}

variable "cloudwatch_log_group" {
  type        = string
  description = "Cloudwatch log group name for wordpress"
}

variable "wordpress" {
  type = map(string)
  description = "wordpress configuration"
  
}