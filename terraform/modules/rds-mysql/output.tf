output "mysql_info" {
  value = {
    endpoint = aws_db_instance.mysql.address
    port     = aws_db_instance.mysql.port
    username = aws_db_instance.mysql.username
    password = random_password.rds_master_password.result
  }
  description = "Information about the MySQL RDS instance."
  sensitive   = true
}