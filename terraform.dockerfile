FROM alpine:3.18

# Descargar y descomprimir Terraform
RUN apk add --no-cache wget unzip && \
    wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip && \
    unzip /tmp/terraform.zip -d /usr/local/bin && \
    rm /tmp/terraform.zip && \ 
    apk add ca-certificates

# Establecer el usuario a nobody por razones de seguridad
USER nobody

# Definir el punto de entrada como 'terraform'
ENTRYPOINT [ "terraform" ]
