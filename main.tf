variable "domain_name" {
  description = "The name of the domain for our website."
  default     = "mi-perimera-app-terraform.org"
}

# Definir una política IAM que permita acceso público a los objetos del bucket S3
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "PublicReadGetObject"
    effect = "Allow"
    actions = [ "s3:GetObject" ]
    principals {
      type = "*"
      identifiers = [ "*" ]
    }
    resources = [ "arn:aws:s3:::${var.domain_name}/*" ]
  }
}


resource "aws_s3_bucket" "website" {
  bucket = var.domain_name
  policy = data.aws_iam_policy_document.bucket_policy.json
}

resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "website" {
  depends_on = [
    aws_s3_bucket_ownership_controls.website,
    aws_s3_bucket_public_access_block.website,
  ]

  bucket = aws_s3_bucket.website.id
  acl    = "public-read"
}



# Configurar el sitio web para el bucket S3
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.htm"
  }

  error_document {
    key = "error.htm"
  }
}

# Output para mostrar la URL del bucket S3 como un sitio web
output "website_bucket_url" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}
