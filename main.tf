resource "aws_iam_role" "lambda_exec" {
  name = "${var.lambda_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Effect="Allow", Principal={ Service="lambda.amazonaws.com" }, Action="sts:AssumeRole" }]
  })
}
resource "aws_iam_role_policy_attachment" "basic_exec" {
  role = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_cloudwatch_log_group" "lambda" {
  name = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 14
}
resource "aws_lambda_function" "crud" {
  function_name = var.lambda_name
  role          = aws_iam_role.lambda_exec.arn
  runtime       = "java17"
  handler       = var.lambda_handler
  filename         = var.jar_path
  source_code_hash = filebase64sha256(var.jar_path)
  memory_size   = var.memory_mb
  timeout       = var.timeout_seconds
  environment { variables = {
    SPREADSHEET_ID = var.spreadsheet_id
    SHEET_NAME     = var.sheet_name
    GOOGLE_CREDENTIALS_JSON_BASE64 = var.google_credentials_json_base64
  }}
  depends_on = [aws_cloudwatch_log_group.lambda]
}
resource "aws_apigatewayv2_api" "http" {
  name = "${var.lambda_name}-api"
  protocol_type = "HTTP"
  cors_configuration {
    allow_headers = ["*"]
    allow_methods = ["GET","POST","PUT","DELETE","OPTIONS"]
    allow_origins = ["*"]
    max_age = 3600
  }
}
resource "aws_apigatewayv2_integration" "lambda" {
  api_id = aws_apigatewayv2_api.http.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.crud.invoke_arn
  payload_format_version = "1.0"
}
resource "aws_apigatewayv2_route" "orders" {
  api_id = aws_apigatewayv2_api.http.id
  route_key = "ANY /orders"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}
resource "aws_apigatewayv2_route" "orders_id" {
  api_id = aws_apigatewayv2_api.http.id
  route_key = "ANY /orders/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}
resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.http.id
  name   = "$default"
  auto_deploy = true
}
resource "aws_lambda_permission" "allow_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.crud.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http.execution_arn}/*/*"
}
