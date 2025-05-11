
resource "aws_instance" "app" {
  instance_type     = "t2.micro"
  availability_zone = "eu-west-3a"
  ami               = "ami-0160e8d70ebc43ee1"
  key_name =   aws_key_pair.terraform_key.key_name
  user_data = data.local_file.script.content
  security_groups = [
    aws_security_group.app_sg.name
  ]
  tags = {
    "tname"= each.value
    "group"= var.ec2_instance_group_tag
  }
  for_each = toset(var.vm)
}

resource "aws_security_group" "app_sg" {
    name = "terraform_sg"
    description = "hey"

    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        # prefix_list_ids = [aws_vpc_endpoint.my_endpoint.prefix_list_id]
        cidr_blocks = ["${data.local_file.client_ip.content}/32", "0.0.0.0/0"]
    }
    ingress {
        from_port       = 0
        to_port         = 8080
        protocol        = "tcp"
        # prefix_list_ids = [aws_vpc_endpoint.my_endpoint.prefix_list_id]
        cidr_blocks = ["${data.local_file.client_ip.content}/32", "0.0.0.0/0"]
    }
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        # prefix_list_ids = [aws_vpc_endpoint.my_endpoint.prefix_list_id]
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        "mlkj" = "bobi"
    }
}

resource "tls_private_key" "my_rsa_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = tls_private_key.my_rsa_key.public_key_openssh
  provisioner "local-exec" { 
    command = "echo '${tls_private_key.my_rsa_key.private_key_pem}' > ./myKey.pem"
  }
}

data "local_file" "script" {
  filename = "./script.sh"
}

data "local_file" "client_ip" {
    filename = "./client_ip"
}


# =====DB=====

data "aws_instances" "ec2_my_admin_instances" {
  filter {
    name = "tag:group"
    values = [var.ec2_instance_group_tag]
  }
}

resource "aws_security_group" "allow_pg" {
  name        = "Aurora_sg"
  description = "Security group for RDS Aurora"
  
  ingress {
    description = "Postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [for ip in data.aws_instances.ec2_my_admin_instances.public_ips : "${ip}/32"]
  }
}

data "aws_subnets" "vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpcId] 
  }
}

resource "aws_db_subnet_group" "mydb_subnet_group" {
  name       = "mydb-subnet-group"
  subnet_ids = data.aws_subnets.vpc_subnets.ids
  
  tags = {
    Name = "MyDBSubnetGroup"
  }
}

resource "aws_db_instance" "postgres" {
  identifier        = "postgres-db"
  engine            = "postgres"
  engine_version    = "15.7"
  instance_class    = "db.t3.micro" 
  allocated_storage = 20
  name              = "myweshdb"
  username          = "postgres"
  password          = "StrongPassword123!"
  port              = 5432
  publicly_accessible = true

  vpc_security_group_ids = [aws_security_group.allow_pg.id]
  db_subnet_group_name   = aws_db_subnet_group.mydb_subnet_group.name

  skip_final_snapshot = true

  tags = {
    Name = "MyPostgresDB"
  }
}

