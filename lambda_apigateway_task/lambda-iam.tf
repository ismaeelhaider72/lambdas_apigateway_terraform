resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = file("/home/ismaeel/Documents/lambda_fucntions/iam/lambda-policy.json")
}

//////////////////// Create policy ////////////////////
/////////////////////////////////////////////////////


resource "aws_iam_role_policy" "create_policy" {
  name = "create_policy"
  role = aws_iam_role.create_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = file("/home/ismaeel/Documents/lambda_fucntions/iam/createpolicy.json")
}


//////////////////// get policy ////////////////////
/////////////////////////////////////////////////////

resource "aws_iam_role_policy" "get_policy" {
  name = "get_policy"
  role = aws_iam_role.get_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = file("/home/ismaeel/Documents/lambda_fucntions/iam/getpolicy.json")
}

//////////////////// delete policy ////////////////////
/////////////////////////////////////////////////////

resource "aws_iam_role_policy" "delete_policy" {
  name = "delete_policy"
  role = aws_iam_role.delete_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = file("/home/ismaeel/Documents/lambda_fucntions/iam/deletepolicy.json")
}



//////////////////// delete policy ////////////////////
/////////////////////////////////////////////////////

resource "aws_iam_role_policy" "update_policy" {
  name = "update_policy"
  role = aws_iam_role.update_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = file("/home/ismaeel/Documents/lambda_fucntions/iam/updatepolicy.json")
}





//////////////////// Create Role ////////////////////
/////////////////////////////////////////////////////

resource "aws_iam_role" "create_role" {
  name = "create_role"

  assume_role_policy =  file("iam/lambda-assume-policy.json")
}


//////////////////// get Role ////////////////////
/////////////////////////////////////////////////////



resource "aws_iam_role" "get_role" {
  name = "get_role"

  assume_role_policy =  file("iam/lambda-assume-policy.json")
}

//////////////////// delete Role ////////////////////
/////////////////////////////////////////////////////


resource "aws_iam_role" "delete_role" {
  name = "delete_role"

  assume_role_policy =  file("iam/lambda-assume-policy.json")
}

//////////////////// update Role ////////////////////
/////////////////////////////////////////////////////


resource "aws_iam_role" "update_role" {
  name = "update_role"

  assume_role_policy =  file("iam/lambda-assume-policy.json")
}
