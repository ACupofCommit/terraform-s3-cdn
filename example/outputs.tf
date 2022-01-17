output "output" {
  description = "Resource informations"
  value       = <<EOT
# To check your resources,
$ terraform state list
EOT
}
