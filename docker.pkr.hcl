variable "ansible_host" {
  default = "packer-docker-base"
}

variable "docker_instance_type" {
  type = string
  # Valid values:
  # - base:        Install CIS AL2, Custom 
  # - docker:      Install base, CIS Docker
  default = "base"
}

source "docker" "amazon_linux_2" {
  image       = "packer-docker-base:base"
  pull        = false
  commit      = true
  run_command = ["-d", "-i", "-t", "--rm", "--cap-add=NET_ADMIN", "--name", var.ansible_host, "{{.Image}}", "/bin/bash"]
}

build {
  sources = [
    "source.docker.amazon_linux_2"
  ]

  provisioner "ansible" {
    user          = "root"
    playbook_file = "./main.yml"
    extra_arguments = [
      "--skip-tags=ignore_on_docker",
      "--extra-vars", "instance_type=${var.docker_instance_type}",
      "--extra-vars", "ansible_host=${var.ansible_host}",
      "--extra-vars", "ansible_connection=docker",
      "--extra-vars", "systemd_available=true"
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "packer-docker-base"
      tags       = ["latest"]
    }
  }
}
