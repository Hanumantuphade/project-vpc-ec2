terraform {
  backend "s3" {

    bucket         = "hamu-kops-testbkt78677.k8s.local"
    key            = "prod/terraform.tfstate"
    encrypt        = true
    region         = "ap-south-1"
    use_lockfile   = true
  }
}