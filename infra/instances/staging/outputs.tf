output "staging_dns" {
  value = aws_instance.staging_cicd_demo.public_dns
}