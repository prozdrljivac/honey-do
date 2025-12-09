# Tasks

## Figure out how to have response params defined on api gateway

Currently in our lambda functions we return headers, which I think should not be their task. That part of logic should be in the API Gateway.
Look into how to set it up with Terraform so this part of logic lives in response params in the AWS Api Gateway.

[More Info](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration)
