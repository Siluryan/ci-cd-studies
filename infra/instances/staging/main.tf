data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]

  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"] # Canonical official
}

resource "aws_instance" "staging-cicd" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.siluryan-dev-public-1.id

  tags = {
    "Name" = "staging_cicd"
  }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name         = "terraform-state-lock-dynamo"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_vpc" "siluryan-dev-vpc" {
  cidr_block = "10.42.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name         = "siluryan-dev-vpc"
    Organization = "Siluryan"
  }
}

resource "aws_subnet" "siluryan-dev-private-1" {
  vpc_id     = aws_vpc.siluryan-dev-vpc.id
  cidr_block = "10.42.1.0/24"

  tags = {
    Name = "siluryan-dev-private-1"
  }
}

resource "aws_subnet" "siluryan-dev-private-2" {
  vpc_id     = aws_vpc.siluryan-dev-vpc.id
  cidr_block = "10.42.2.0/24"

  tags = {
    Name = "siluryan-dev-private-2"
  }
}

resource "aws_subnet" "siluryan-dev-public-1" {
  vpc_id     = aws_vpc.siluryan-dev-vpc.id
  cidr_block = "10.42.10.0/24"

  tags = {
    Name = "siluryan-dev-public-1"
  }
}

resource "aws_subnet" "siluryan-dev-public-2" {
  vpc_id     = aws_vpc.siluryan-dev-vpc.id
  cidr_block = "10.42.11.0/24"

  tags = {
    Name = "siluryan-dev-public-2"
  }
}

resource "aws_internet_gateway" "siluryan-dev-igw" {
  vpc_id = aws_vpc.siluryan-dev-vpc.id

  tags = {
    Name         = "siluryan-dev-igw"
    Organization = "Siluryan"
  }
}

resource "aws_route_table" "siluryan-dev-private-rt" {
  vpc_id = aws_vpc.siluryan-dev-vpc.id

  tags = {
    Name         = "siluryan-dev-private-rt"
    Organization = "Siluryan"
  }
}

resource "aws_route_table" "siluryan-dev-public-rt" {
  vpc_id = aws_vpc.siluryan-dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.siluryan-dev-igw.id
  }

  tags = {
    Name         = "siluryan-dev-public-rt"
    Organization = "Siluryan"
  }
}

resource "aws_default_security_group" "siluryan-dev-default-sg" {
  vpc_id = aws_vpc.siluryan-dev-vpc.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_default_network_acl" "siluryan-dev-default-nacl" {
  default_network_acl_id = aws_vpc.siluryan-dev-vpc.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}