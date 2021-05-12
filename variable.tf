terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

variable "ext_port" {
  type    = number
  default = 1880
}

variable "int_port"{
  type    = number
  deafult = 1880

}

variable "container_count"{
  type    = number
  deafult = 1
}

resource "random_string" "random" {
  count   = var.container_count
  length  = 4
  special = false
  upper   = false
}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "docker_container" "nodered_container" {
  count = var.container_count
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = var.int_port
    external = var.ext_port
  }
}

output "Container_IP_Address" {
  value       = [for i in docker_container.nodered_container[*]:join (":", [i.ip_address], i.ports[*]["external"])]

}


output "container_name1" {
  value       = docker_container.nodered_container[*].name
  description = "The name of the container1"
}
