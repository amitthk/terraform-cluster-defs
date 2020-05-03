output "spot_hdpspark_master" {
  value = "${aws_spot_instance_request.spot_hdpspark_master.*.public_ip}"
}