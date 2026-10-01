variable "custom_vpc_name" {
  description = "The name of the custom VPC network."
  type        = string
  default     = "custom-vpc"
}
variable "custom_subnet_name" {
  description = "The name of the custom subnet."
  type        = string
  default     = "custom-subnet" 
}
variable "zone" {
  description = "The zone to deploy the VM instance."
  type        = string
  default     = "asia-south1-a"
}