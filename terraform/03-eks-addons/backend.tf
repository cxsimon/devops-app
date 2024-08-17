terraform {
  backend "s3" {
    bucket  = "devops-task-terrafrom-states"
    key     = "eks-addons.tfstate"
    region  = "us-east-2"
  }
}
