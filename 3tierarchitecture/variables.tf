variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC_cidr block"
  type        = string
}

variable "public-web-subnet-1-cidr" {
  default     = "10.0.1.0/24"
  description = "public_web_subnet1"
  type        = string
}

variable "public-web-subnet-2-cidr" {
  default     = "10.0.2.0/24"
  description = "public_web_subnet2"
  type        = string
}

variable "private-app-subnet-1-cidr" {
  default     = "10.0.3.0/24"
  description = "private_app_subnet1"
  type        = string
}

variable "private-app-subnet-2-cidr" {
  default     = "10.0.4.0/24"
  description = "private_app_subnet2"
  type        = string
}

variable "private-db-subnet-1-cidr" {
  default     = "10.0.5.0/24"
  description = "private_db_subnet1"
  type        = string
}

variable "private-db-subnet-2-cidr" {
  default     = "10.0.6.0/24"
  description = "private_db_subnet2"
  type        = string
}

variable "ssh-locate" {
  default     = "yourip"
  description = "ip address"
  type        = string
}

variable "database-instance-class" {
  default     = "db.t2.micro"
  description = "The Database Instance type"
  type        = string
}

variable "multi-az-deployment" {
  default     = false
  description = "Create a Standby DB Instance"
  type        = bool
}