FROM alpine

RUN wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip

RUN unzip /tmp/terraform.zip -d /usr/local/bin

RUN rm /tmp/terraform.zip

USER nobody

ENTRYPOINT [ "terraform" ]
