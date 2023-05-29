.DEFAULT_GOAL := check

password_update:
	cd pass_update && docker build -t pass_update .
	docker run -it --rm -v $(PWD)/defaults:/root/defaults pass_update

init:
	packer init .

lint: init
	ansible-lint -c ./defaults/ansible-lint.yml --exclude .github --exclude roles/auditing  --exclude defaults/users.yml

check: init
	packer fmt -check .
	packer validate .

fmt: init
	packer fmt .

test:
	docker build -t packer-docker-base:base .
	packer build -var "docker_instance_type=$(type)" docker.pkr.hcl 

sso:
	aws sso login

deploy:
	packer build -var "instance_type=$(type)" ami.pkr.hcl

