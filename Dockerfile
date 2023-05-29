FROM amazonlinux:2

RUN yum install -y python3 sudo shadow-utils vim tar libicu sudo yum-utils awscli util-linux cronie

RUN adduser -m ec2-user
RUN echo "ec2-user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ec2-user

RUN mkdir -p /var/lib/cloud/scripts/per-boot/

USER ec2-user
