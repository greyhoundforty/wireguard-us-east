variable "region" {
  type        = string
  description = "The region where the VPC resources will be deployed."
  default     = "us-east"
}

variable "tycho_ssh_key" {
  type        = string
  description = "The SSH Key that will be added to the compute instances in the region."
  default     = "ryan-tycho-us-east"
}

variable "hyperion_ssh_key" {
  type        = string
  description = "The SSH Key that will be added to the compute instances in the region."
  default     = "hyperion-us-east"
}

variable "default_instance_profile" {
  type    = string
  default = "bx2-2x8"
}

variable "instance_count" {
  type        = string
  description = "Default number of compute instances to deploy."
  default     = "1"
}

variable "os_image" {
  type        = string
  description = "OS Image to use for VPC instances. Default is currently Ubuntu 18."
  default     = "ibm-ubuntu-18-04-1-minimal-amd64-2"
}

variable "resource_group" {
  type        = string
  description = "Resource group where resources will be deployed."
  default     = "CDE"
}

variable "remote_ssh_ip" {
  type        = string
  description = "IP of your local machine"
  default     = ""
}

variable "client_public_key" {
  type        = string
  default     = ""
  description = "Wireguard client public key"
}

variable "consul_token" {
  type    = string
  default = ""
}


variable "consul_http" {
  type    = string
  default = ""
}

variable "vpc_name" {
  type        = string
  description = "Name of vpc and related resources"
  default     = "wgtest"
}