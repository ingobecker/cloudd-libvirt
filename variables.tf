variable "name" {
  type        = string
  description = "An unique identifier for the image."
}

variable "context" {
  type        = string
  description = "Path to the install containers build context."
}

variable "user" {
  type        = string
  description = "Primary user, mainly for debugging."
  default     = ""
}

variable "password" {
  type        = string
  description = "Primary user, mainly for debugging."
  default     = ""
}

variable "ssh_key" {
  type        = string
  description = "SSH-Key for primary user, mainly for debugging."
  default     = ""
}

variable "fedora_url" {
  type        = string
  description = "Cloud image to use for the cloudd vm."
  default     = "https://download.fedoraproject.org/pub/fedora/linux/releases/32/Cloud/x86_64/images/Fedora-Cloud-Base-32-1.6.x86_64.qcow2"
}

variable "memory" {
  type        = number
  description = "Amount of RAM used by the VM in GB."
  default     = 4
}

variable "storage_root" {
  type        = number
  description = "Size of the root device in GB."
  default     = 10
}

variable "storage_vol" {
  type        = number
  description = "Size of the external storage device in GB."
  default     = 10
}
