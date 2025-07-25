output "config_recorder_id" {
  value = aws_config_configuration_recorder.config_recorder.id
}

output "delivery_channel_id" {
  value = aws_config_delivery_channel.config_delivery_channel.id
}