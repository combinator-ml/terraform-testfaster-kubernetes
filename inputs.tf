variable "name" {
  type = string
  default = "Terraformed Testfaster"
}

variable "testfaster_token" {
  type = string
}

variable "testfaster_endpoint" {
  type = string
  default = "https://testfaster.ci"
}

variable "kernel_image" {
  type = string
  default = "quay.io/testfaster/ignite-kernel"
}

variable "os_dockerfile" {
  type = string
  default = "FROM quay.io/testfaster/kube-ubuntu\nRUN apt-get update && apt-get install -y socat"
}

variable "docker_bake_script" {
  type = string
  default = ""
}

variable "preload_docker_images" {
  type = list(string)
  default = []
}

variable "prewarm_script" {
  type = string
  default = ""
}

variable "kubernetes_version" {
  type = string
  default = "v1.18.3" // set to "" to disable k8s provisioning
}

variable "cpus" {
  type = number
  default = 4
}

variable "memory" {
  type = string
  default = "8GB"
}

variable "disk" {
  type = string
  default = "50GB"
}

variable "prewarm_pool_size" {
  type = number
  default = 1
}

variable "max_pool_size" {
  type = number
  default = 2
}

variable "default_lease_timeout" {
  type = string
  default = "1h"
}
