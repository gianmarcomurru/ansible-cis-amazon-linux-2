.DEFAULT_GOAL := check

type ?= base
all:
        : '$(type)'

init:
	packer init .

lint:
	ansible-lint

check: init
	packer fmt -check .
	packer validate .

fmt: init
	packer fmt .

password_update:
	cd pass_update && docker build -t pass_update .
	docker run -it --rm -v $(PWD)/defaults:/root/defaults pass_update

docker: init
	docker build -t packer-docker-base:base .
	packer build -var "docker_instance_type=$(type)" docker.pkr.hcl 

test: docker
	docker run -it packer-docker-base

sso:
	aws sso login

ami:
	packer build -var "instance_type=$(type)" ami.pkr.hcl

