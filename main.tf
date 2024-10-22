variable "domain_name" {
  default = "mi-sitio-de-prueba-terraform"
}

# Definir una política IAM que permita acceso público a los objetos del bucket S3
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    actions = [ "s3:GetObject" ]
    principals {
      type        = "*"
      identifiers = [ "*" ]
    }
    # Aplicar la política a todos los objetos dentro del bucket
    resources = [ "arn:aws:s3:::${var.domain_name}/*" ]
  }
}

# Crear el bucket S3 con permisos públicos y configurarlo como sitio web estático
resource "aws_s3_bucket" "website" {
  bucket = var.domain_name              # Usar la variable directamente
  acl    = "public-read"                # Permisos de solo lectura públicos

  # Aplicar la política de acceso público generada
  policy = data.aws_iam_policy_document.bucket_policy.json

  website {
    index_document = "index.htm"  # Documento principal de tu sitio web
    error_document = "error.htm"  # Página de error
  }
}

# Output para mostrar la URL del bucket S3 como un sitio web
output "website_bucket_url" {
  value = aws_s3_bucket.website.website_endpoint  # URL del sitio web generado por S3
}
