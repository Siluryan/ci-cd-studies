output "staging_dns" {
  value = aws_instance.staging-cicd.public_dns
}