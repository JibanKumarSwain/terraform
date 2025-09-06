# main.tf work are like we write all configuration on there this is the most importent part in terraform 
# , we deciered on there what we need and how to create that on there.



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

# 1st normal
# # EC2 instance
# resource "aws_instance" "server" {
#   ami                    = "ami-02d26659fd82cf299"
#   instance_type          = "t3.micro"
#   key_name               = aws_key_pair.try1.key_name
#   subnet_id              = aws_subnet.public_sb_b.id          # <-- always specify subnet
#   vpc_security_group_ids = [aws_security_group.new_security.id] # <-- use IDs, not names

#   tags = {
#     Name = "servertest"
#   }
# }

#2nd update
# EC2 instance
# resource "aws_instance" "server" {
#   count = 2                                             # meta argument using this for increage the ec2 after that need to upadte on output.tf also
#   ami                    = var.ec2_ami_id
#   instance_type          = var.ec2_instance_type
  
#   user_data = file("${path.module}/nginx.sh")
  
      
#   key_name               = aws_key_pair.try1.key_name
#   subnet_id              = aws_subnet.public_sb_b.id          # <-- always specify subnet
#   vpc_security_group_ids = [aws_security_group.new_security.id] # <-- use IDs, not names
                 

#   root_block_device {
#     volume_size = var.ec2_root_storage_size
#     volume_type = var.ec2_root_storage_type
#   }

#   tags = {
#     Name = "servertest"
#   }
# }

#3nd update 

resource "aws_instance" "server" {

  for_each = tomap ({                                      # we are define the different type of server and there name and how many server we need 
    server-micro = "t2.micro"
    server-medium = "t2.medium"
  })                                         
  ami                    = var.ec2_ami_id
  instance_type          = each.value                  # after adding the different for_each now thay take the ec2 type from here
  
  user_data = file("nginx.sh")
  
      
  key_name               = aws_key_pair.try1.key_name
  subnet_id              = aws_subnet.public_sb_b.id          # <-- always specify subnet
  vpc_security_group_ids = [aws_security_group.new_security.id] # <-- use IDs, not names
                 

  root_block_device {
    volume_size = var.env == "prd" ? 20 : var.ec2_default_root_storage_size
    volume_type = var.ec2_root_storage_type
  }

  tags = {
    Name = each.key
  }
}



