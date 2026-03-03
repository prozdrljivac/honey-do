resource "aws_dynamodb_table" "table" {
  name         = "${var.app_name}-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PK"
  range_key    = "SK"

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}-table"
    Environment = var.environment
  }
}
