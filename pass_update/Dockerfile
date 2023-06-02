
FROM amazonlinux:2

RUN yum install -y sudo shadow-utils su passwd yum-utils 
RUN yum install -y python3 python3-pip
RUN pip3 install ruamel.yaml

COPY update_password.sh /root/update_password.sh
COPY update_yaml.py /root/update_yaml.py
COPY defaults/users.yml /root/defaults/users.yml
RUN chmod +x /root/update_password.sh
RUN chmod +x /root/update_yaml.py
WORKDIR /root

RUN users=$(python3 -c 'from update_yaml import names; names()')
RUN for user in $users; do useradd -m $user; done

# Set password policy, min 14 chars, at least 1 uppercase, 1 lowercase, 1 digit, 1 special char
RUN echo -e "minlen = 14\nminclass = 4" >> /etc/security/pwquality.conf

USER root
ENTRYPOINT [ "/root/update_password.sh" ]
