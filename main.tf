provider "aws"{
  region = "us-east-1"
}

# STEP 1 = VPS/ 2 PUBLICS SUBNET-------------------------------------------
resource "aws_vpc" "my-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public-1" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-1"
  }
}

resource "aws_subnet" "public-2" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1b"
  tags = {
    Name = "public-2"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "public-1"
  }
}

resource "aws_route_table_association" "public-1-a" {
    subnet_id = aws_subnet.public-1.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-2-a" {
    subnet_id = aws_subnet.public-2.id
    route_table_id = aws_route_table.public.id
}


# STEP2 = EC2-------------------------------------------------------------
resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("my-key.pub")
}

resource "aws_instance" "ec2-inst-1" {
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name =  aws_key_pair.ssh_key.key_name
  subnet_id = "${aws_subnet.public-1.id}"
  tags = {
    Name = "ec2-inst-1"
  }
}

resource "aws_instance" "ec2-inst-2" {
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name =  aws_key_pair.ssh_key.key_name
  subnet_id = "${aws_subnet.public-2.id}"
  tags = {
    Name = "ec2-inst-2"
  }
}

#STEP 4 = NODE JS (ANSIBLE)

resource "aws_security_group" "sg" {
  name        = "MYSecurityGroup"
  description = "Permitir acceso de puertos"

  ingress {
    from_port   = 22  # SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/* STEP 3 = LOAD BALANCER

resource "aws_lb" "my_lb" {  ##EXAMPLEEEE
  name               = "my-load-balancer"
  load_balancer_type = "application"
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

data "aws_instance" "instance" {
  filter {
    name = "tag:Name"
    values = ["ec2-inst-1"]
  }
}
resource "aws_lb_target_group" "tg" {
  name = "my-targetgroup"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.my-vpc.id
}

resource "aws_lb_target_group_attachment" "attachment" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = aws_instance.instance.id
}

resource "aws_lb_listener_rule" "tg_rule" {
  listener_arn = aws_lb_listener.listener.arn

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition {
    host_header {
      values = ["devopschallenge.ml"]
    }
  }
}

data "aws_route53_zone" "zone" {
  name = var.domain_name
}

resource "aws_route53_record" "endpoint" {
  zone_id = aws_route53_zone.zone.zone_id
  type = "A"
  name = "devopschallenge.ml"

  alias {
    name = aws_lb.lb.dns_name
    #!zone_id = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}
*/