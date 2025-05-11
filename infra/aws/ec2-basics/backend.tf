terraform {
  backend "s3" {
    bucket = "my-bucket-lfj493"  
    key    = "terraform-state-file"
    region = "eu-west-3"
  }
}