# Database parameters specify how the database is configured. 
# For example, database parameters can specify the amount of resources, such as memory, 
# to allocate to a database.

resource "aws_db_parameter_group" "mysql_standalone_parametergroup" {
  name   = "${var.project}-${var.environment}-mysql-standalone-parametergroup"
  family = "mysql8.0"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

}

# An AWS DB option group is a feature that enables and configures 
# optional features specific to a particular database engine.
resource "aws_db_option_group" "mysql_standalone_optiongroup" {
    name = "${var.project}-${var.environment}-mysql-standalone-optiongroup"
    engine_name = "mysql"
    major_engine_version = "8.0"
}

# Connect DB
resource "aws_db_subnet_group" "mysql_standalone_subnetgroup" {
    name = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"
    subnet_ids = [
        aws_subnet.private_subnet_1a.id,
        aws_subnet.private_subnet_1c.id
    ]

    tags = {
        Name = "${var.project}-${var.environment}-mysql-stanalone-subnetgroup"
        Project = var.project
        Env = var.environment
    }
}

# RDS Instance 
resource "random_string" "db_password" {
    length = 16
    special = false
}

resource "aws_db_instance" "mysql_standalone" {
    engine = "mysql"
    engine_version = "8.0.20"
    identifier =  "${var.project}-${var.environment}-mysql-standalone"

    username = "admin"
    password = random_string.db_password.result

    instance_class = "db.t2.micro"

    allocated_storage = 20
    max_allocated_storage = 50
    storage_type = "gp2"
    storage_encrypted = false

    multi_az = false
    availability_zone = "ap-northeast-1a"
    db_subnet_group_name = aws_db_subnet_group.mysql_standalone_subnetgroup.name
    vpc_security_group_ids = [aws_security_group.db_sg.id]
    publicly_accessible = false
    port = 3306

    

}