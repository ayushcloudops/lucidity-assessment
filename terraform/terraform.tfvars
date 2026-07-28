
project    = "hello-world"
aws_region = "ap-south-1"

vpc_cidr           = "10.0.0.0/20"
az_count           = 2
single_nat_gateway = true

cluster_version                = "1.34"
cluster_endpoint_public_access = false

node_instance_types = ["t3.medium"]
node_capacity_type  = "ON_DEMAND"
node_min_size       = 1
node_max_size       = 2
node_desired_size   = 1
