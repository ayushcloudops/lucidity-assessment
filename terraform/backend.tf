terraform {
  backend "s3" {
    bucket       = "ayush-bucket-22"
    key          = "lucidity/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
