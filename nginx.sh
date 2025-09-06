# In this file we setuping like that type during the creating the infra thay can install and Run the nginx
# we use this file in side the "main.tf section of ec2 add the anme of user_data"
#!/bin/bash


#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

