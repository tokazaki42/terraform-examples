# RDS
resource "aws_db_subnet_group" "praivate-db" {
    name        = "praivate-db"
    subnet_ids  = [ aws_subnet.private-db1.id , aws_subnet.private-db2.id ]
    tags = {
        Name = "praivate-db"
    }
}

resource "aws_db_instance" "test-db" {
  identifier           = "test-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.22"
  instance_class       = "db.t3.micro"
  name                 = "testdb"
  username             = var.rds-user
  password             = var.rds-password
  vpc_security_group_ids  = [aws_security_group.praivate-db-sg.id]
  db_subnet_group_name = aws_db_subnet_group.praivate-db.name
  skip_final_snapshot = true
}