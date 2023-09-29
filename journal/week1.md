# Terraform Beginner Bootcamp 2023 week 1

## Root Module Structure 

```
Project_Root
|
├── main.tf             # everything else.
├── variable.tf         # stores the structure of input variables.
├── terraform.tfvars    # the data of variables we want to load into our terraform project.
├── output.tf           # stores our outputs.
├── providers.tf        # defined required providers and their configuration.
└── README.md           # required for root modules.
```


[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables 

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### Terraform Cloud Variables 

In terrraform we can set two kinds of variables:
- Envirnment Variables - those that you would set in your bash terminal e.g. AWS credentials 
- Terraform Variables - those that you would normally set in your tfvars file. 

We can set Terraform Cloud Variables to be sensative so they are not shown visibly in the UI.

### Loading Terraform Input Variables 

We can use the `-var` flag to set an input variable or override a variable in the tfvars file e.g. `terraform -var user_uuid="m-user-id"`

### var-file-flag

Explicit -var Command-Line Flags: If you pass a variable using the -var flag when running Terraform commands (e.g., terraform apply -var="myvar=myvalue"), the value provided via the command-line flag takes the highest precedence. It will override any other values set elsewhere.

### terraform.tfvars

This is the default file to load in any terraform variables in bulk.

### auto.tfvars

terraform.tfvars or .auto.tfvars Files: Terraform can automatically load variable values from files named terraform.tfvars or .auto.tfvars in the working directory. These files should contain variable assignments in the format variable_name = value. Values in these files take precedence over default values defined in the configuration.

### Order of terraform variables 

In Terraform, when defining and working with variables, the order of precedence determines which variable value will take precedence over others if a variable is defined in multiple places. The order of Terraform variable precedence, from highest to lowest, is as follows:

1. Explicit Variable Definitions in Configuration Files: Variables defined within your Terraform configuration files (typically in .tf or .tf.json files) using variable blocks. These are the primary definitions of variables and provide default values for them.

```hcl
variable "example" {
  description = "An example variable"
  type        = string
  default     = "default_value"
}
```

2. Explicit Variable Assignments via -var Command-Line Flags: Variables can be assigned explicit values using the -var command-line flag when running Terraform commands. These values take precedence over default values defined in the configuration.

```bash
terraform apply -var="example=new_value"
```
3. Environment Variables (TF_VAR_*): Terraform allows you to set variable values using environment variables with names starting with TF_VAR_. Environment variables take precedence over default values but are overridden by explicit -var flags.

```bash
export TF_VAR_example=environment_value
```
4. `terraform.tfvars` or `.auto.tfvars` Files: Terraform can automatically load variable values from files named terraform.tfvars or .auto.tfvars in the working directory. These files should contain variable assignments in the format variable_name = value. Values in these files take precedence over default values defined in the configuration.

5. Variable Values in Remote State (if using remote state): If you're using remote state in Terraform (e.g., Terraform Cloud, Terraform Enterprise, or a remote backend like AWS S3), you can store variable values there. These values take precedence over default values but can be overridden by explicit -var flags.

6. Variable Defaults in Module Blocks: If you're using modules, you can define default values for module input variables within the module block. These default values take precedence if no other value is provided for the module variable.

7. HCL Expressions (if using variable expressions): In some cases, you can use HCL expressions to compute variable values based on other variables or data sources. These computed values take precedence over default values.

### Terraform Import 



## Dealing with Configuration Drift

When someone manually deletes deployed resources via the console, by running `terraform plan` this configuration drift will be identified and you can run `terraform apply`which will restore the resouce and deploy any new configurations. This is what terraform does best, some other IAC tools may not detect this. 

### What happens if we lose the State File

If you lose the `state file` you most likely have to tear down all your cloud infastructure manually. 

You can use `terraform import` but this wont work for all cloud resources, you need to check the terraform provides documentation for which resources support `import`

### Fix Missing Resources with Terraform Import
```h
import {
  to = aws_s3_bucket.bucket
  id = "bucket-name"
}
``` 
```terraform import aws_s3_bucket.bucket bucket-name```

[Terraform Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)


### Fix Mannual Configuration 

If someone goes and deletes or modifys cloud resources manually through ClickOps. 

If we run `terraform plan` again it will put our infastructure back into the expected state fixing configuration drift.


### Dealing with Configuration Drift

When someone manually deletes deployed resources via the console, by running `terraform plan` this configuration drift will be identified and you can run `terraform apply`which will restore the resouce and deploy any new configurations. This is what terraform does best, some other IAC tools may not detect this. 

### What happens if we lose the State File

If you lose the `state file` you most likely have to tear down all your cloud infastructure manually. 
You can use `terraform import` but this wont work for all cloud resources, you need to check the terraform provides documentation for which resources support `import`

### Fix Missing Resources with Terraform Import

```h
import {
  to = aws_s3_bucket.bucket
  id = "bucket-name"
}
``` 
```terraform import aws_s3_bucket.bucket bucket-name```
[Terraform Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)
[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Fix Mannual Configuration 

If someone goes and deletes or modifys cloud resources manually through ClickOps. 
If we run `terraform plan` again it will put our infastructure back into the expected state fixing configuration drift.

### Fix using Terraform Refresh

```sh
terraform apply -refresh-only -auto-approve
```

## Terraform Modules

### Terraform Module Structure

It is recommended to place in a `modules` directory when locally developing modules but you can it whatever you like i.e. we have named our first one `modules/terrahouse_aws`
A module should contain.

### Passing Input Variables 

We can pass input variables to our module 
The module has to declare the terraform variables in it's own `variables.tf`
```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  s3_bucket_name = var.s3_bucket_name
}
```

### Module Sources 

Using the source we can import the module from various places e.g. 
- locally
- GitHub
- Terraform Registry 
```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```
[Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

## Fix using 