resource "aws_s3_bucket" "tf-state-bucket" {
  bucket = "devops-task-terrafrom-states"

  tags = {
    DevOps_Task = "true"
  }
}

terraform {
  backend "s3" {
    bucket  = "devops-task-terrafrom-states"
    key     = "network.tfstate"
    region  = "us-east-2"
  }
}
