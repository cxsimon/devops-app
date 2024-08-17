

resource "aws_instance" "bastion" {
  ami           = "ami-05c3dc660cb6907f0"  
  instance_type = "t2.micro"
  key_name      = "devops-task-key-pair"
  associate_public_ip_address = true
  subnet_id              = "subnet-082a27bc88eba32d7"
  security_groups        = ["sg-0842bfcec11817fcc"]
  tags = {
    Name = "bastion-host"
    devops_task = "true"
  }
}