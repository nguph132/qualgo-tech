resource "aws_db_instance" "mysql" {
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = var.max_allocated_storage
  storage_type            = var.storage_type
  engine                  = "mysql"
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  db_name                 = var.database_name
  username                = var.master_username
  password                = random_password.rds_master_password.result
  parameter_group_name    = aws_db_parameter_group.custom_mysql_parameter_group.id
  publicly_accessible     = var.publicly_accessible
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot

  vpc_security_group_ids = [aws_security_group.mysql.id]
  db_subnet_group_name   = aws_db_subnet_group.mysql_subnet_group.name

  tags = var.tags
}

resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "${var.database_name}-subnet-group"
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

resource "aws_db_parameter_group" "custom_mysql_parameter_group" {
  name        = "${var.database_name}-parameter-group"
  family      = var.mysql_family
  description = "Custom parameter group for MySQL"

  dynamic "parameter" {
    for_each = var.mysql_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}

resource "aws_security_group" "mysql" {
  name        = "${var.database_name}-rds-sg"
  description = "Allow MySQL access"
  vpc_id      = var.vpc_id

  ingress {
    description = "Ingress: Allow self access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Ingress: Allow access RDS from Backend"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = var.allowed_source_security_group_id
  }

  ingress {
    description = "Ingress: Allow access RDS from K8S"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  tags = var.tags
}

# Generate a random password for the RDS master user
resource "random_password" "rds_master_password" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  number  = true
}