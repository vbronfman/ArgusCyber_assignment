# Creates EC2 instance along with creation of key pair. Runs remote-exec
resource "aws_instance" "jenkins-instance" {
  count = 1
  // ami           = try(var.ami,[]) ? var.ami : "ami-041feb57c611358bd" // "ami-01c647eace872fc02" AWS Amazon x86_64
  // ami = try(var.ami,"ami-041feb57c611358bd")
  ami = "ami-041feb57c611358bd"
  instance_type ="t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y docker
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              EOF
  
  tags = {
    Name = "argus-jenkins"
  }

  # https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec 
  provisioner "remote-exec" {
    on_failure = continue
    inline = [ 
        "docker version > /tmp/docker.version"
     ]
  }
# Establishes connection to be used by all
# generic remote provisioners (i.e. file/remote-exec)
  connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = file(local_file.tf-key.filename)
  }
  key_name = aws_key_pair.web.id
  //vpc_security_group_ids = [aws_security_group.ssh-access.id]

# If when = destroy is specified, the provisioner will run when the resource it is defined within is destroyed. 
/*
   provisioner "local-exec" {
    when    = destroy
    command = "echo 'Destroy-time provisioner'"
  }
*/  
}

resource "aws_key_pair" "web" {
  key_name = "tf-key-pair"
  public_key = tls_private_key.rsa.public_key_openssh
  }
  
resource "tls_private_key" "rsa" {
    algorithm = "RSA"
    rsa_bits  = 4096
  }

resource "local_file" "tf-key" {
    content  = tls_private_key.rsa.private_key_pem
    //filename = "~/.ssh/tf-key-pair"
    filename = "tf-key-pair"
    file_permission = "0600"
    // directory_permission = "0644"
    // provisioner "local-exec" {
    // command = "chmod 644 ./.ssh/tf-key-pair"
    // }
}

output "server_public_ipv4" {
    value = aws_instance.jenkins-instance[*].public_ip
}


resource "aws_security_group" "jenkins_access" {
  name        = "jenkins-access-sg"
  description = "Security group for Jenkins instance access"
  
  # Define ingress rule for HTTP (port 80)
  ingress {
    from_port   = 0
    to_port     = 48080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow access from any IPv4 address (open to the world)
  }
  
  # Define egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow outbound traffic to any destination
  }
}



/*
resource "aws_eip" "elastic_ip" {
  
}

*/

/*
module "alb_example_complete-alb" {
  source  = "terraform-aws-modules/alb/aws//examples/complete-alb"
  version = "9.2.0"
}
*/
/*
module "security-group_example_complete" {
  source  = "terraform-aws-modules/security-group/aws//examples/complete"
  version = "5.1.0"
}
*/