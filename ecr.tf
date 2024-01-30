provider "aws" {
  region = "us-east-1"  # Specify your desired AWS region
#  profile = var.aws-profile
   profile = "Lucy"
}


resource "aws_ecr_repository" "vlad_bronfman" {
  name                 = "vlad.bronfman"
  image_tag_mutability = "MUTABLE"  # Set the image tag mutability (default is "MUTABLE")
}