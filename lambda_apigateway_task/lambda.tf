locals{

    lambda_zip_location_create = "output/ismaeelCreatedFunctionp.zip"
    lambda_zip_location_get = "output/ismaeelGetITFucntionp.zip"
    lambda_zip_location_delete = "output/ismaeeldeleteFunctionp.zip"
    lambda_zip_location_update = "output/ismaeelUpdateFunctionp.zip"
}



data "archive_file" "create" {
  type        = "zip"
  source_file = "/home/ismaeel/Documents/lambda_fucntions/ismaeelCreatedFunctionp.py"
  output_path = "${local.lambda_zip_location_create}"
}



data "archive_file" "get" {
  type        = "zip"
  source_file = "/home/ismaeel/Documents/lambda_fucntions/ismaeelGetITFucntionp.py"
  output_path = "${local.lambda_zip_location_get}"
}


data "archive_file" "delete" {
  type        = "zip"
  source_file = "/home/ismaeel/Documents/lambda_fucntions/ismaeeldeleteFunctionp.py"
  output_path = "${local.lambda_zip_location_delete}"
}


data "archive_file" "update" {
  type        = "zip"
  source_file = "/home/ismaeel/Documents/lambda_fucntions/ismaeelUpdateFunctionp.py"
  output_path = "${local.lambda_zip_location_update}"
}






///////////////////////////////// create function ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////


resource "aws_lambda_function" "create_lambda" {
  filename      = "${local.lambda_zip_location_create}"
  function_name = "ismaeelCreatedFunctionp"
  role          = aws_iam_role.create_role.arn
  handler       = "ismaeelCreatedFunctionp.lambda_handler"

  #source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "python3.7"


}



///////////////////////////////// get function ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////


resource "aws_lambda_function" "get_lambda" {
  filename      = "${local.lambda_zip_location_get}"
  function_name = "ismaeelGetITFucntionp"
  role          = aws_iam_role.get_role.arn
  handler       = "ismaeelGetITFucntionp.lambda_handler"

  #source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "python3.7"


}




///////////////////////////////// delete function ////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////


resource "aws_lambda_function" "delete_lambda" {
  filename      = "${local.lambda_zip_location_delete}"
  function_name = "ismaeeldeleteFunctionp"
  role          = aws_iam_role.delete_role.arn
  handler       = "ismaeeldeleteFunctionp.lambda_handler"

  #source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "python3.7"


}




///////////////////////////////// update function ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////


resource "aws_lambda_function" "update_lambda" {
  filename      = "${local.lambda_zip_location_update}"
  function_name = "ismaeelUpdateFunctionp"
  role          = aws_iam_role.update_role.arn
  #role          = "arn:aws:iam::489994096722:role/service-role/ismaeelUpdateFunction-role-0vtte6k9"
  handler       = "ismaeelUpdateFunctionp.lambda_handler"

  #source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "python3.7"


}



////////////////////////////// Api gateway ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

resource "aws_api_gateway_rest_api" "api" {
  name = "ismaeelapiTF"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = "resource"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}



/////////////////// create Method and intergrations request/responses //////////////////
///////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////


resource "aws_api_gateway_method" "create_method2" {
  depends_on = [
    aws_api_gateway_model.postmodel1
  ]  
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "NONE"
  request_models = {
    "application/json" = aws_api_gateway_model.postmodel1.name
  }
  request_validator_id= aws_api_gateway_request_validator.validator.id
}


resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.create_method2.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.create_lambda.invoke_arn
}





resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.create_method2.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
  depends_on = [
    aws_api_gateway_integration.integration
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.create_method2.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code


}
//////////// create model /////////////


resource "aws_api_gateway_model" "postmodel1" {
  rest_api_id  = aws_api_gateway_rest_api.api.id
  name         = "postmodel1"
  description  = "a JSON schema"
  content_type = "application/json"

  schema = file("/home/ismaeel/Documents/lambda_fucntions/models/postmodel1.json")

}

////////////// request validator /////////////////

resource "aws_api_gateway_request_validator" "validator" {
  name                        = "Validatebody"
  rest_api_id                 = aws_api_gateway_rest_api.api.id
  validate_request_body       = true
  validate_request_parameters = true
}

/////////////////// update Method and intergrations request/responses  //////////////////
///////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////


resource "aws_api_gateway_method" "update_method2" {
  depends_on = [
    aws_api_gateway_model.updatemodel1
  ]    
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "PUT"
  authorization = "NONE"
  request_models = {
    "application/json" = aws_api_gateway_model.updatemodel1.name
  }
  request_validator_id= aws_api_gateway_request_validator.validator.id
}






resource "aws_api_gateway_integration" "update_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.update_method2.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.update_lambda.invoke_arn
}




resource "aws_api_gateway_method_response" "response_2001" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.update_method2.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse3" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.update_method2.http_method
  status_code = aws_api_gateway_method_response.response_2001.status_code


}



//////////// update model /////////////


resource "aws_api_gateway_model" "updatemodel1" {
  
  rest_api_id  = aws_api_gateway_rest_api.api.id
  name         = "updatemodel1"
  description  = "a JSON schema"
  content_type = "application/json"

  schema = file("/home/ismaeel/Documents/lambda_fucntions/models/updatemodel1.json")

}


/////////////////// delete Method and intergrations  request/responses //////////////////
///////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

resource "aws_api_gateway_method" "delete_method" {
  depends_on = [
    aws_api_gateway_model.deletemodel1
  ]  
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "DELETE"
  authorization = "NONE"
  request_models = {
    "application/json" = aws_api_gateway_model.deletemodel1.name
  }
  request_validator_id= aws_api_gateway_request_validator.validator.id
}  




resource "aws_api_gateway_integration" "delete_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.delete_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.delete_lambda.invoke_arn
}




resource "aws_api_gateway_method_response" "response_2002" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.delete_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse4" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.delete_method.http_method
  status_code = aws_api_gateway_method_response.response_2002.status_code


}

////////// delete model //////////////
resource "aws_api_gateway_model" "deletemodel1" {
  rest_api_id  = aws_api_gateway_rest_api.api.id
  name         = "deletemodel1"
  description  = "a JSON schema"
  content_type = "application/json"

  schema = file("/home/ismaeel/Documents/lambda_fucntions/models/deletemodel1.json")

}


/////////////////// Get Method and intergrations  request/responses //////////////////
///////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

resource "aws_api_gateway_method" "get_method" {
  depends_on = [
    aws_api_gateway_model.getmodel1
  ]    
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "GET"
  authorization = "NONE"
  request_models = {
    "application/json" = aws_api_gateway_model.getmodel1.name
  }
  request_validator_id= aws_api_gateway_request_validator.validator.id
}    




resource "aws_api_gateway_integration" "get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.get_lambda.invoke_arn
}




resource "aws_api_gateway_method_response" "get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.get_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "get_Integration_Response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.get_method.http_method
  status_code = aws_api_gateway_method_response.get_response_200.status_code


}

//////////////////////// get model ////////////////////////////////////////////
resource "aws_api_gateway_model" "getmodel1" {
  rest_api_id  = aws_api_gateway_rest_api.api.id
  name         = "getmodel1"
  description  = "a JSON schema"
  content_type = "application/json"

  schema = file("/home/ismaeel/Documents/lambda_fucntions/models/getmodel1.json")

}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////// update  function execution permission //////////
resource "aws_lambda_permission" "apigw_lambda2" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.AWS_REGION}:${var.AWS_ACCOUNT_ID}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.update_method2.http_method}${aws_api_gateway_resource.resource.path}"


}

///////////// delete function execution permission //////////
resource "aws_lambda_permission" "delete_apigw_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.AWS_REGION}:${var.AWS_ACCOUNT_ID}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.delete_method.http_method}${aws_api_gateway_resource.resource.path}"


}


///////////// create function execution permission //////////
resource "aws_lambda_permission" "creat_apigw_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.AWS_REGION}:${var.AWS_ACCOUNT_ID}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.create_method2.http_method}${aws_api_gateway_resource.resource.path}"


}

///////////// Get function execution permission //////////
resource "aws_lambda_permission" "get_apigw_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.AWS_REGION}:${var.AWS_ACCOUNT_ID}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.get_method.http_method}${aws_api_gateway_resource.resource.path}"


}


////////////// Api Deployment stage //////////////////////

resource "aws_api_gateway_deployment" "example" {

  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.resource.id,
      aws_api_gateway_method.create_method2,
      aws_api_gateway_method.update_method2,
      aws_api_gateway_method.delete_method,
      aws_api_gateway_method.get_method,    
      aws_api_gateway_integration.integration.id,
      aws_api_gateway_integration.update_integration.id,
      aws_api_gateway_integration.delete_integration.id,
      aws_api_gateway_integration.get_integration.id
    ]))
  }  

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "example" {
 
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "dev2"
}

