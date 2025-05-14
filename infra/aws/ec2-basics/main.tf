resource "aws_instance" "app" {
  instance_type     = "t2.micro"
  availability_zone = "eu-west-3a"
  ami               = "ami-0160e8d70ebc43ee1"
  key_name =   aws_key_pair.terraform_key.key_name
  user_data = data.local_file.script.content
  security_groups = [ 
    aws_security_group.app_sg.name
   ]
  tags = {
    "tname"= each.value
  }
  for_each = toset(var.vm)
}



resource "aws_security_group" "app_sg" {
    name = "terraform_sg"
    description = "hey"

    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        # prefix_list_ids = [aws_vpc_endpoint.my_endpoint.prefix_list_id]
        cidr_blocks = ["${data.local_file.client_ip.content}/32", "0.0.0.0/0"]
    }
    tags = {
        "mlkj" = "bobi"
    }
}

resource "tls_private_key" "my_rsa_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = tls_private_key.my_rsa_key.public_key_openssh
  provisioner "local-exec" { 
    command = "echo '${tls_private_key.my_rsa_key.private_key_pem}' > ./myKey.pem"
  }
}

data "local_file" "script" {
  filename = "./script.sh"
}

data "local_file" "client_ip" {
    filename = "./client_ip"
}

# resource "local_file" "key" {
#     content = aws_key_pair.terraform_key.public_key
#     filename = "./my_key.pub"
# }




// security ->
