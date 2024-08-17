terraform {
  backend "s3" {
    bucket  = "devops-task-terrafrom-states"
    key     = "eks.tfstate"
    region  = "us-east-2"
  }
}
