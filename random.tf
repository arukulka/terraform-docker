terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

resource "random_string" "random1" {
  length  = 4
  special = false
  upper   = false
}

resource "random_string" "random2" {
  length  = 4
  special = false
  upper   = false
}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "docker_container" "nodered_container1" {
  name  = join("-", ["nodered", random_string.random1.result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    # external = 1880
  }
}

resource "docker_container" "nodered_container2" {
  name  = join("-", ["nodered", random_string.random2.result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    # external = 1880
  }
}


output "Container1_IP_Address" {
  value       = join(":", [docker_container.nodered_container1.ip_address, docker_container.nodered_container1.ports[0].external])
  description = "IP Address of the container"
}

output "Container2_IP_Address" {
  value       = join(":", [docker_container.nodered_container2.ip_address, docker_container.nodered_container2.ports[0].external])
  description = "IP Address of the container"
}

output "container_name1" {
  value       = docker_container.nodered_container1.name
  description = "The name of the container1"
}

output "container_name2" {
  value       = docker_container.nodered_container2.name
  description = "The name of the container2"
}
