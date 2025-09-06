# variables are use for the that like we are not hardcodeed on the services types on main.tf direcatilly 
# thay way we are use the variable block , in fetucher we need to update somethink we can update eassly


# variable

variable "ec2_instance_type" {
    default = "t2.micro"  
    type = string
}

variable "ec2_default_root_storage_size" {
  
  default = "10"
  type = number

}

variable "ec2_root_storage_type" {
    default = "gp3"
    type = string
  
}


variable "ec2_ami_id" {
    default = "Add the image ID on ther "                 # add the image ID on there 
    type = string
  
}

variable "env" {
    default = "prd"
    type = string

}
