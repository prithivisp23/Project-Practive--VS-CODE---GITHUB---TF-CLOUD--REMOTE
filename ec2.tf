#Instance resource block
#Public Instance-1
resource "aws_instance" "pubweb1" {
  ami           = var.ami_id
  instance_type = var.instance_type
  associate_public_ip_address = true
  subnet_id = aws_subnet.pubsub1.id
  vpc_security_group_ids = [aws_security_group.pub-seg.id]
  key_name = "terraform-project" 
  user_data = file("web-apps.sh")

  tags = {
    Name = "webserver-1"
  }
  # Connection script for SSH (LOCAL -> REMOTE)Pub-inst-1
   connection {
    type     = "ssh"
    host     = self.public_ip
    user     = "ec2-user"
    password = ""
    private_key = file("private-key/terraform-project.pem")
  }
  # File Provisioner script for transfer file(LOCAL -> REMOTE) Pub-inst-1
  provisioner "file" {
    source      = "apps/index.html"
    destination = "/tmp/index.html"
  }
  # Remote provisoner script for file execution from remote - pub inst-1
  provisioner "remote-exec" {
    inline = [
      "sleep 120",  # Will sleep for 120 seconds to ensure Apache webserver is provisioned using user_data
      "sudo cp /tmp/index.html /var/www/html"
    ]
  }
}

#Public Instance-2
resource "aws_instance" "pubweb2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  associate_public_ip_address = true
  subnet_id = aws_subnet.pubsub2.id
  vpc_security_group_ids = [aws_security_group.pub-seg.id]
  key_name = "terraform-project" 
  user_data = file("web-apps.sh")

  tags = {
    Name = "webserver-2"
  }
  # Connection script for SSH (LOCAL -> REMOTE)- Pub-inst-2
   connection {
    type     = "ssh"
    host     = self.public_ip
    user     = "ec2-user"
    password = ""
    private_key = file("private-key/terraform-project.pem")
  }
    # File Provisioner script for transfer file(LOCAL -> REMOTE) Pub-inst-2
  provisioner "file" {
    source      = "apps/index.html"
    destination = "/tmp/index.html"
  }
  # Remote provisoner script for file execution from remote - pub inst-2
  provisioner "remote-exec" {
    inline = [
      "sleep 120",  # Will sleep for 120 seconds to ensure Apache webserver is provisioned using user_data
      "sudo cp /tmp/index.html /var/www/html"
    ]
  }
}