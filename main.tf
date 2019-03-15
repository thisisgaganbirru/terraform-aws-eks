data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
    Env  = "dev"
  }
}

resource "aws_subnet" "main" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.subnet_cidr}"
  availability_zone = "${var.availability_zone}"

  tags = {
    Name = "main-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "main-igw"
  }
}

resource "aws_instance" "web" {
  ami                    = "${data.aws_ami.amazon_linux.id}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${aws_subnet.main.id}"
  vpc_security_group_ids = ["${aws_security_group.web_sg.id}"]
  key_name               = "${var.key_name}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name = "web-server"
    Env  = "dev"
  }
}
