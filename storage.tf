resource "aws_ebs_volume" "web_data" {
  availability_zone = "${var.availability_zone}"
  size              = 20
  type              = "gp2"

  tags = {
    Name = "web-data-volume"
    Env  = "dev"
  }
}

resource "aws_volume_attachment" "web_data_attach" {
  device_name = "/dev/xvdf"
  volume_id   = "${aws_ebs_volume.web_data.id}"
  instance_id = "${aws_instance.web.id}"
}

resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = ["${aws_subnet.main.id}", "${aws_subnet.main_2.id}"]

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

  name     = "${var.db_name}"
  username = "${var.db_username}"
  password = "${var.db_password}"

  db_subnet_group_name   = "${aws_db_subnet_group.main.name}"
  vpc_security_group_ids = ["${aws_security_group.web_sg.id}"]

  skip_final_snapshot = true

  tags = {
    Name = "main-db"
    Env  = "dev"
  }
}
