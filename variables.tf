variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "lambda_name" {
  type    = string
  default = "crud-lambda-sheets"
}

variable "lambda_handler" {
  type    = string
  default = "com.example.OrderHandler::handleRequest"
}

variable "jar_path" {
  type        = string
  description = "Ruta local al JAR (target/crud-lambda-sheets-1.0.0.jar)"
}

variable "memory_mb" {
  type    = number
  default = 512
}

variable "timeout_seconds" {
  type    = number
  default = 25
}

variable "spreadsheet_id" {
  type = string
}

variable "sheet_name" {
  type    = string
  default = "Orders"
}

variable "google_credentials_json_base64" {
  type      = string
  sensitive = true
}
