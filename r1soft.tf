provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "r1soft"  {
  instance_type               = "${var.instance_type}"
  ami                         = "${var.ami}"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = "true"
  security_groups             = ["allow_ssh_and_r1soft"]

  #This will help you provision file
  provisioner "file" {
    source      = "r1soft.repo"
    destination = "/tmp/r1soft.repo"

    connection {
      host        = "${self.public_ip}"
      type        = "ssh"
      user        = "${var.user}"
      private_key = "${file(var.ssh_key_location)}"
    }
  }
  
  provisioner "remote-exec" {
    connection {
      host        = "${self.public_ip}"
      type        = "ssh"
      user        = "${var.user}"
      private_key = "${file(var.ssh_key_location)}"
    }

    inline = [
      # Change below r1soft
      "sudo /tmp/r1soft.repo /etc/yum.repos.d",
      "sudo  yum install serverbackup-enterprise -y",
      "sudo r1soft-setup --user admin --password Redhat2019 --http-port 8080",
    ]
  }
}
