output "aws_instance" {
    value                       = aws_instance.this
}

output "metaport_id" {
    value                       = metanetworks_metaport.this
}

output "rendered_otacs" {
    value                       = local.otacs
}