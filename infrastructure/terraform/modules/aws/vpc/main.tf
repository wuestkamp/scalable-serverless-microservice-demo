//resource "aws_vpc" "main" {
//  cidr_block       = "10.0.0.0/16"
//  instance_tenancy = "dedicated"
//
//  tags = {
//    Name = "main"
//  }
//}

# http://www.davidc.net/sites/default/subnets/subnets.html

//resource "aws_subnet" "one" {
//  vpc_id     = "${aws_vpc.main.id}"
//  cidr_block = "10.0.0.0/17" # 10.0.0.0 - 10.0.127.255
//
//  tags = {
//    Name = "One"
//  }
//}
//
//resource "aws_subnet" "two" {
//  vpc_id     = "${aws_vpc.main.id}"
//  cidr_block = "10.1.128.0/17" # 10.0.128.0 - 10.0.255.255
//
//  tags = {
//    Name = "Two"
//  }
//}
//
//output "subnet_ids" {
//  value = [aws_subnet.one.id, aws_subnet.two.id]
//}
