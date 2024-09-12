
## VPC Module

This VPC terraform module will provision the following resources:


1. One **VPC** with the provided CIDR
2. Number of **public and private subnets** provided through input variables
3. One **IGW** for the public subnets
4. One **NAT gateway** for the private subnets
5. One **Public route table** that will associate all the public subnets and will have an entry of the IGW
6. One **private route table** that will associate all the private subnets and will have an entry of the NAT gateway.
7.  Enables **DNS hostnames & DNS support** in the VPC