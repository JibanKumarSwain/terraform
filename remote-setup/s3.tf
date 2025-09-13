# we are doing the remote backend 


resource "aws_s3_bucket" "s3_bucket" {
  bucket = "terraform-s3-infrasetup"

  tags = {
    Name        = "terraform-s3-infrasetup"
    Environment = "Dev"
  }
}