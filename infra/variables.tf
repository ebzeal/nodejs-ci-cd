variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "ci-cd-nodejs"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "container_port" {
  description = "Port the app listens on inside the container"
  type        = number
  default     = 3000
}

variable "cpu" {
  description = "CPU units for the Fargate task"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Memory (MiB) for the Fargate task"
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "Number of ECS service tasks to run"
  type        = number
  default     = 1
}
