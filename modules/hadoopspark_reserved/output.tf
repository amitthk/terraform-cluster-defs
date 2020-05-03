output "reserved_hdpspark_master" {
  value = "${aws_instance.reserved_hdpspark_master.*.private_ip}"
}

output "reserved_hdpspark_bastion" {
  value = "${aws_instance.reserved_hdpspark_bastion.*.public_ip}"
}