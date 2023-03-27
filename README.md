# AWS SAM - Lambda - Ruby 3.2 - Container Image

I have created this simple HelloWorld serverless application using Ruby 3.2.1 to demostrate the usage of Lambda with container image using a ruby version (3.2.1) that at the time I created it, Lambda did not have native support

## Folder structure
* `lib:` contains all the code that usually is placed into a lambda layer and shared between multiple functions
* `hello_word:` folder where the lambda code is implemented

## Dependencies
* aws_lambda_ric
* httparty
* dotenv
* docker

## Deploy

* sam build
* sam deploy --guided --debug

