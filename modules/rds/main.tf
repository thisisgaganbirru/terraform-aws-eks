resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = [var.subnet_id, var.subnet_id_2]

  tags = {
    Name = "main-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier        = "main-db"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t2.micro"
  allocated_storage = 20
  storage_type      = "gp2"

  name     = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group_id]

  skip_final_snapshot = true

  tags = {
    Name = "main-db"
  }
}
