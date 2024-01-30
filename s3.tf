resource "aws_s3_bucket" "example_bucket" {
  bucket = "your-unique-bucket-name-vlad-bronfman-12"  # Specify your desired bucket name (must be globally unique)
  #acl    = "private"  # Specify the access control list (ACL) for the bucket
  
  
   versioning {
     enabled = true
  }
  
  # Uncomment the following block if you want to enable server-side encryption for the bucket
  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       sse_algorithm = "AES256"
  #     }
  #   }
  # }
  
   logging {
     target_bucket = "vlad-bronfman-logging-bucket"  # Specify the bucket where logs will be stored
     target_prefix = "log/"
   }
}

