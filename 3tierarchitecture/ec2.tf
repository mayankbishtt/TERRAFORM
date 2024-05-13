data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "PublicWebTemplate" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public-web-subnet-1.id
  vpc_security_group_ids = [aws_security_group.webserver-security-group.id]
  key_name               = "key1"
  user_data              = file("install-apache.sh")

  tags = {
    Name = "web-asg"
  }
}

resource "aws_key_pair" "key1" {
  key_name = "key1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCugycvZrt6uj/nQHXzMlx1dkPaZTwLH9vBn6Vh3d6GISGCJ/KnS8fN2KQfZXO5/mntpOW7eFr3qDDHBFHyjrr+qFX2FMa5ku5ZzxFbqamwzNfM/uoWyM2+CeYMVnHPqQ7CYOit5gbb+qvF8FhWfn4FmELzdTXKtfoH5g6dlAFcfjYHZRGfiQkvVsOeNXSsNpnL5Rxe9PLvUF8MJRfvLNZtildBC1bSTtb571mH3sHGy/DzT6UJdOLrWn9L9wWxG31f5wOZbhckD9DyIOrrPT/j7powGAtrGm9W/dK0OjCVwfMBA0ZMhCqPJgVTv8rskHXBcKaKwtCY4U8w9UiH2pSZ36B0IloYNfwt4S7mNR6vEU2kOjQqjQOrGn0W9Sv0Zwz/9nGbfP+Hec7FWNHTeKiq7yfc/qPfqMBgt2RTerN2/ybQkcJlxHT0rcHkRkfPxyX1ypbUTGqO2nr5JEVXXaszPHQZomVKZN1Gn1EZyU7KRQj1DBiAWns+pLloW45IWkc= mayank@del1-lhp-n72140"
}


resource "aws_instance" "private-app-template" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private-app-subnet-1.id
  vpc_security_group_ids = [aws_security_group.ssh-security-group.id]
  key_name               = "key1"

  tags = {
    Name = "app-asg"
  }
}