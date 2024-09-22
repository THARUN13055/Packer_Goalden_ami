packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "java-ubuntu" {
  ami_name               = "java-test_ami-{{timestamp}}"
  source_ami             = "ami-0e86e20dae9224db8"
  ami_description        = "ubuntu machine"
  region                 = "us-east-1"
  skip_region_validation = false
  tags = {
    created = "tharun"
    project = "paynpro"
  }

  instance_type = "t2.micro"
  ssh_username  = "ubuntu"

  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 8
    volume_type           = "gp3"
    throughput            = 125
    delete_on_termination = true
  }
}


build {
  name    = "test-java-ami"
  sources = ["source.amazon-ebs.java-ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo mkdir -p /tmp/scripts",
      "sudo chown ubuntu:ubuntu /tmp/scripts",
      "sudo mkdir -p /tmp/target",
      "sudo chown ubuntu:ubuntu /tmp/target",
      "sudo mkdir -p /tmp/nginx_conf_file",
      "sudo chown ubuntu:ubuntu /tmp/nginx_conf_file",
      "sudo mkdir -p /tmp/paynpro_certificate",
      "sudo chown ubuntu:ubuntu /tmp/paynpro_certificate"
    ]
  }
  # target folder
  provisioner "file" {
    source = "./target/paynpro_java_test.war"
    destination = "/tmp/target/paynpro_java_test.war"
  }

  # scripts folder

  provisioner "file" {
    source = "./scripts/crontab.sh"
    destination = "/tmp/scripts/crontab.sh"
  }

  provisioner "file" {
    source = "./scripts/log_automation.sh"
    destination = "/tmp/scripts/log_automation.sh"
  }

  provisioner "shell" {
    inline = [
      "sudo mkdir -p /opt/s3_log_backup",
      "sudo chown ubuntu:ubuntu /opt/s3_log_backup",
      "sudo mv /tmp/scripts/log_automation.sh /opt/s3_log_backup/log_automation.sh"
    ]
  }

  provisioner "file" {
    source = "./scripts/mysql_cli.sh"
    destination = "/tmp/scripts/mysql_cli.sh"
  }

  provisioner "file" {
    source = "./scripts/nginx_install.sh"
    destination = "/tmp/scripts/nginx_install.sh"
  }

  provisioner "file" {
    source = "./scripts/tomcat_install.sh"
    destination = "/tmp/scripts/tomcat_install.sh"
  }

  # paynpro_certificate

  provisioner "file" {
    source = "./paynpro_certificate/paynpro_com.crt"
    destination = "/tmp/paynpro_certificate/paynpro_com.crt"
  }

  provisioner "file" {
    source = "./paynpro_certificate/paynpro_com.key"
    destination = "/tmp/paynpro_certificate/paynpro_com.key"
  }

  provisioner "file" {
    source = "./paynpro_certificate/www.paynpro.com.chained.crt"
    destination = "/tmp/paynpro_certificate/www.paynpro.com.chained.crt"
  }

  provisioner "file" {
    source = "./nginx_conf_file/paynpro_com.conf"
    destination = "/tmp/nginx_conf_file/paynpro_com.conf"
  }

  provisioner "shell" {
    inline = [
      "sudo bash /tmp/scripts/nginx_install.sh",
      "sleep 5",
      "sudo bash /tmp/scripts/tomcat_install.sh",
      "sleep 5",
      "sudo bash /tmp/scripts/crontab.sh",
      "sleep 5",
      "sudo bash /tmp/scripts/mysql_cli.sh",
      "sleep 5"
    ]
  }
}