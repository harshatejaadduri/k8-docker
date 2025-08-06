resource "aws_instance" "k8" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_all_docker.id]

  # need more for docker
  root_block_device {
    volume_size = 50
    volume_type = "gp3" 
  }
  user_data = file("docker.sh")
  #iam_instance_profile = "TerraformAdmin"
  tags = {
     Name = "Kubernetes"
  }
  iam_instance_profile = "TerrafromEc2Access"
}

resource "aws_security_group" "allow_all_docker" {
    name        = "allow_all_docker"
    description = "allow all traffic"

    ingress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    lifecycle {
      create_before_destroy = true
    }

    tags = {
        Name = "allow-all-docker"
    }
}