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
