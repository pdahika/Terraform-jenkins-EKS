# vpc

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr

  azs            = data.aws_availability_zones.azs.names
  public_subnets = var.public_subnets
  map_public_ip_on_launch = true

  enable_dns_hostnames = true
  enable_dns_support   = true # Recommended to add this

  tags = {
    Name        = "jenkins-vpc" # Fixed: Capital "N" in Name (AWS convention)
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = { # FIXED: Changed to public_subnet_tags (singular)
    Name = "jenkins-subnet"
  }
}

#security group

module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "user-service"
  description = "Security group"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    Name = "jenkins-sg"
  }
}

#ec2

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["one", "two"])

  name = "instance-${each.key}"

  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = "shot"
  monitoring             = true
  vpc_security_group_ids = [module.sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  
  # CRITICAL: Disable security group creation
  create_security_group = false
  
  # Use base64 encoding and force replacement
  user_data = file("${path.module}/jenkins-install.sh")
  user_data_replace_on_change = true
  
  availability_zone = data.aws_availability_zones.azs.names[0]

  tags = {
    Name        = "jenkins-server-${each.key}"
    Terraform   = "true"
    Environment = "dev"
  }

}