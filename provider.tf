terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.11.0"
    }
  }
}
  backend "s3" {                                         # for that we create a separest folder the name is remote-setup we do the setup of terraform backend
  bucket = "terraform-s3-infrasetup"
  key = "terraform.tfstate"
  region = "ap-south-1"
  dynamodb_table = "remote-backend"
  }
}

provider "aws" {
  region = "ap-south-1"

}
