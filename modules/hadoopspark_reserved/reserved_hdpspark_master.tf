resource "aws_instance" "reserved_hdpspark_master" {
    ami = "${var.ami_id}"
    instance_type = "${var.instance_type}"
    key_name = "${var.aws_keypair_name}"
    associate_public_ip_address = true
    availability_zone = "${var.availability_zone}"
    count = "${var.reserved_hdpspark_master_count}"
    security_groups = ["${aws_security_group.hdpsparkstack_private.id}"]
    subnet_id="${aws_subnet.private_nat_1.id}"


  tags {
      Name = "reserved_hdpspark_master-${count.index}"
      Description = "reserved_hdpspark_master-${count.index}"
  }
  ebs_block_device {
    device_name = "/dev/sda1"
    delete_on_termination = true
    volume_size = "${var.master_block_device_size}"
  }
  volume_tags {
      Name = "reserved_hdpspark_master-${count.index}"
  }
  root_block_device {
    delete_on_termination = true
 }

  provisioner "local-exec" {
    command = "aws ec2 create-tags --resources ${self.id} --tags Key=Name,Value=reserved_hdpspark_master-${count.index}"

    environment {
      AWS_ACCESS_KEY_ID = "${var.aws_access_key}"
      AWS_SECRET_ACCESS_KEY = "${var.aws_secret_key}"
      AWS_DEFAULT_REGION = "${var.region}"
    }
  }
}



resource "null_resource" "after-reserved_hdpspark_master" {
  depends_on = ["aws_instance.reserved_hdpspark_master"]
  provisioner "local-exec" {
    command = "echo ' reserved_hdpspark_masters ${join(",",aws_instance.reserved_hdpspark_master.*.id)} ${join(",",aws_instance.reserved_hdpspark_master.*.private_ip)} ${join(",",aws_instance.reserved_hdpspark_master.*.public_ip)}' >> inventory.txt"
  }
}

resource "aws_route53_record" "nodecname" {
  zone_id = "${aws_route53_zone.intranet.zone_id}"
  count = "${var.reserved_hdpspark_master_count}"
  name = "${var.hadoop_stack_name}-node${count.index}"
  type = "A"
  ttl = "300"
  records = ["${element(aws_instance.reserved_hdpspark_master.*.private_ip,count.index)}"]
}
