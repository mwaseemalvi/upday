
module "k8s-cluster" {

  source       = "terraform-aws-modules/eks/aws"
  version      = "v5.1.0"

  subnets      = [ aws_subnet.public-subnet.id, aws_subnet.private-subnet.id ]
  vpc_id       = aws_vpc.upday.id

  worker_groups = [
    {
      instance_type        = "m4.4xlarge"
      asg_max_size         = 5
      asg_desired_capacity = 5
    }
  ]

  tags = {
    environment = "upday-development"
  }

  kubeconfig_name = "upday_cluster"
  cluster_name = "upday_cluster"

}