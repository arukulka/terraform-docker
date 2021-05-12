terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

resource "random_string" "random" {
  count   = 2
  length  = 4
  special = false
  upper   = false
}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "docker_container" "nodered_container" {
  count = 2
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    # external = 1880
  }
}
//The "count" object can only be used in "module", "resource", and "data"
//blocks, and only when the "count" argument is set (Refer the terraform bookmark for more info)

output "Container1_IP_Address" {
  value       = join(":", [docker_container.nodered_container[0].ip_address, docker_container.nodered_container[0].ports[0].external])
  description = "IP Address of the container"
}

output "Container2_IP_Address" {
  value       = join(":", [docker_container.nodered_container[1].ip_address, docker_container.nodered_container[1].ports[0].external])
  description = "IP Address of the container"
}

output "container_name1" {
  value       = docker_container.nodered_container[0].name
  description = "The name of the container1"
}

output "container_name2" {
  value       = docker_container.nodered_container[1].name
  description = "The name of the container2"
}
