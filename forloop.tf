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


output "Container_IP_Address" {
  value       = [for i in docker_container.nodered_container[*]:join (":", [i.ip_address], i.ports[*]["external"])]

}


output "container_name1" {
  value       = docker_container.nodered_container[*].name
  description = "The name of the container1"
}
