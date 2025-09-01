# we creata vpc for new Infra 

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"                         # This is the range for the VPC  
    enable_dns_support = true                          # Needed for DNS resolution inside VPC
    enable_dns_hostnames = true                        # Neded if you want publice DNS name for EC2
    
    tags = {
        Name = "my-vpc"                                # Helpful name tag in AWS console
    }
}


# creating the Internet Gatway

resource "aws_internet_gateway" "new_igw" {
    vpc_id = aws_vpc.main.id
    
    tags = {
        Name = "new-igw"
    }
}


# then we creat the 2 public subnet for the EC2

resource "aws_subnet" "public_sb_a" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "new-pub-SB-a"
    }
}


resource "aws_subnet" "public_sb_b" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "new-pub-SB-b"
    }
}


# then we create the 2 private subnet for the EC2

resource "aws_subnet" "new_piv_SB_a" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = false

    tags = {
        Name = "new-piv-SB-a"
    }
}

resource "aws_subnet" "new_piv_SB_b" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = false

    tags = {
        Name = "new-piv-SB-b"
    }
}


# create the Route Table 

resource "aws_route_table" "new_rt" {
        vpc_id = aws_vpc.main.id

        route{
            cidr_block = "0.0.0.0/0"                        # All internet traffic
            gateway_id = aws_internet_gateway.new_igw.id
        }

        tags = {
            Name = "new-rt"

        }
}

# Accociate Route Table with subnet

# pubilc

resource "aws_route_table_association" "public_sb_a" {
    subnet_id   = aws_subnet.public_sb_a.id
    route_table_id = aws_route_table.new_rt.id
  
}
  
resource "aws_route_table_association" "new_pub_SB_b" {
    subnet_id   = aws_subnet.public_sb_b.id
    route_table_id = aws_route_table.new_rt.id
  
}
  
# creating the new Security group for this infra

resource "aws_security_group" "new_security" {
    name = "new-sg"
    description = "this SG is new"
    vpc_id = aws_vpc.main.id

    tags = {
      Name = "new-sg"
    }

  # now we are set the SG rules

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS open"
  }

  ingress  {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ssh open"
  }

  ingress  {
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Application"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "all access open outbound"
  }

}

# creating the keys

resource "aws_key_pair" "try1" {
  key_name   = "trykey"
  public_key = file("${path.module}/trykey.pub")
}


# EC2 instance
resource "aws_instance" "server" {
  ami                    = "ami-02d26659fd82cf299"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.try1.key_name
  subnet_id              = aws_subnet.public_sb_b.id          # <-- always specify subnet
  vpc_security_group_ids = [aws_security_group.new_security.id] # <-- use IDs, not names

  tags = {
    Name = "servertest"
  }
}
