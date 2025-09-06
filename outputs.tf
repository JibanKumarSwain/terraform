# we are using the outputs.tf like we server IP's after cretng the server now we need to there IP's FOR THAT 
# WE NEED TO login into aws consol but help of outputs.tf we can get the ip's without go inside the 
# outputs.tf file


# # outputs  for count

# output "ec2_public_ip" {
#     value = aws_instance.server[*].public_ip               # use the [*] if we have the multipul ec2 instance we get all ip's help of this 
# }

# output "ec2_public_dns" {
#     value = aws_instance.server[*].public_dns              # use the [*] if we have the multipul ec2 instance we get all dns help of this 
# }
# output "ec2_private_ip" {
#     value = aws_instance.server[*].private_ip              # use the [*] if we have the multipul ec2 instance we get all private ip's help of this 
# }


# this is use for if you are using the for each concation in main.terraform 


output "ec2_public_ip" {
    value = [
        for key in aws_instance.server : key.public_ip
    ]
}

output "ec2_public_dns" {
    value = [
        for key in aws_instance.server : key.public_dns
    ]
  
}

output "ec2_private_ip" {
    value = [
        for key in aws_instance.server : key.private_ip
    ]
  
}