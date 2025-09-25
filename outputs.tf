output "api_base_url" { value = aws_apigatewayv2_stage.default.invoke_url }
output "lambda_name"  { value = aws_lambda_function.crud.function_name }
