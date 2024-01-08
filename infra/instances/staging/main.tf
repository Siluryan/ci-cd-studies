resource "aws_instance" "staging_cicd_demo" {
  ami           = var.aws_base_ami_id
  instance_type = "t2.micro"

  tags = {
    "Name" = "staging_cicd_demo"
  }
}