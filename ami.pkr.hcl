packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "instance_type" {
  type = string
    # Valid values:
    # - base:        Install CIS AL2, Custom 
    # - docker:      Install base, CIS Docker
  default = "base"
}

source "amazon-ebs" "amazon_linux_2" {
  ami_name      = "${var.instance_type}-instance-{{timestamp}}"
  instance_type = "t3.medium"
  region        = "eu-west-1"

  tags = {
    Name = "packer-${var.instance_type}-instance"
    repo = "ansible-cis-amazon-linux-2"
  }

  launch_block_device_mappings {
    device_name           = "/dev/xvda"
    volume_size           = 16
    delete_on_termination = true
  }

  source_ami_filter {
    filters = {
      name                = "amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  ssh_username = "ec2-user"

  vpc_id                      = "vpc-0729fd62"
  subnet_id                   = "subnet-6ec50a37"
  associate_public_ip_address = true
}

build {
  sources = [
    "source.amazon-ebs.amazon_linux_2"
  ]

  provisioner "ansible" {
    user          = "ec2-user"
    use_proxy     = false
    playbook_file = "./main.yml"

    extra_arguments = [
      "--extra-vars", "instance_type=${var.instance_type}",
      # https://github.com/hashicorp/packer-plugin-ansible/issues/69
      "--ssh-extra-args", "-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa",
    ]

    # CentOS have special path to sftp-server
    # https://www.packer.io/plugins/provisioners/ansible/ansible
    sftp_command = "/usr/libexec/openssh/sftp-server -e"
  }
}