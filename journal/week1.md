# Terraform Beginner Bootcamp 2023 week 1

## Table of Contents 

  * [Fixing Tags](#fixing-tags)
  * [Root Module Structure](#root-module-structure)
  * [Terraform and Input Variables](#terraform-and-input-variables)
    + [Terraform Cloud Variables](#terraform-cloud-variables)
    + [Loading Terraform Input Variables](#loading-terraform-input-variables)
    + [var-file-flag](#var-file-flag)
    + [terraform.tfvars](#terraformtfvars)
    + [auto.tfvars](#autotfvars)
    + [Order of terraform variables](#order-of-terraform-variables)
    + [Terraform Import](#terraform-import)
  * [Dealing with Configuration Drift](#dealing-with-configuration-drift)
    + [What happens if we lose the State File](#what-happens-if-we-lose-the-state-file)
    + [Fix Missing Resources with Terraform Import](#fix-missing-resources-with-terraform-import)
    + [Fix Manual Configuration](#fix-mannual-configuration)
    + [Dealing with Configuration Drift](#dealing-with-configuration-drift-1)
    + [What happens if we lose the State File](#what-happens-if-we-lose-the-state-file-1)
    + [Fix Missing Resources with Terraform Import](#fix-missing-resources-with-terraform-import-1)
    + [Fix Mannual Configuration](#fix-mannual-configuration-1)
    + [Fix using Terraform Refresh](#fix-using-terraform-refresh)
  * [Terraform Modules](#terraform-modules)
    + [Terraform Module Structure](#terraform-module-structure)
    + [Passing Input Variables](#passing-input-variables)
    + [Module Sources](#module-sources)
  * [Considerations when using ChatGPT to write Terraform](#considerations-when-using-chatgpt-to-write-terraform)
  * [Working with File in Terraform](#working-with-file-in-terraform)
    + [fileexists function](#fileexists-function)
    + [Filemd5](#filemd5)
    + [Path Variable](#path-variable)
  * [Terraform Locals](#terraform-locals)
  * [Terraform Data Source](#terraform-data-source)
  * [Working with JSON](#working-with-json)
    + [Changing the Lifecycle of Resources](#changing-the-lifecycle-of-resources)
  * [Terraform Data](#terraform-data)
  * [Provisioners](#provisioners)
    + [Local-exec](#local-exec)
    + [Remote-exec](#remote-exec)
    + [For Each Expressions](#for-each-expressions)



## Fixing Tags 

[How to Delete Local and Remote Tags on git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

To delete a local tag:

```sh
git tag -d <tagname>
```
To delete a remote tag:

```sh
git push --delete origin <tagname>
```

To confirm that the tag has been deleted both locally and remotely, you can use the following commands:

To list all local tags, to ensure that the tag you wanted to delete is no longer in the list

```sh
git tag
```

to list all remote tag:

```sh
git ls-remote --tags origin
```


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

## Considerations when using ChatGPT to write Terraform 

LLMs such as ChatGPT may not be trainied on the latest documentation or information about terraform.

It may likely produce older examples that could be depricated often affecting providers. 

[Website hosting](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration)

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object


## Working with File in Terraform 

### fileexists function

This is a built in terraform function, to check the existance of a file. 

```tf
variable "error_html_filepath" {
  description = "The file path for error.html"
  type        = string

  validation {
    condition     = fileexists(var.error_html_filepath)
    error_message = "The provided path for error.html does not exist"
  }
}
```
### Filemd5

filemd5 can be used to ETag documentation within Terraform, without this terraform wouldnt recoginse changes in documetation as it's primarily focus will be to deploy the infastructure. However, if you ETag documentation every time it's changed the ETag number would change allowing for terraform to identify this when running `terraform apply`, where it will also deploy and chage the documets within the infrastructre. 

```tf
resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "error.html"
  source = (var.error_html_filepath)

  etag   = filemd5(var.error_html_filepath)
}
```

[filemd5](https://developer.hashicorp.com/terraform/language/functions/filemd5)

### Path Variable 

In terrafor, there is a special variable called `path` that allows us to reference local paths:
- path.module = get path for the current module 
- path.root = get pathe for the root module 

[Speacial Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

```tf
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "index.html"
  source = "${path.root}public/index.html"
}
```

## Terraform Locals 

Locals allow us to define local variables and it can be very useful when we need to transform data into another format and have refrenced a variable.

[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

```tf
locals {
    s3_origin_id = "MyS3Origin"
}
```

## Terraform Data Source

This allows us to source data from cloud resources, thsi is useful when we want to reference cloud resources without importing them. 

```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

https://developer.hashicorp.com/terraform/language/data-sources

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/billing_service_account

## Working with JSON

We used the jsonencode to create the json policy inline in the hcl.

```js
  jsonencode({"hello"="world"})
{"hello":"world"}
```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

### Changing the Lifecycle of Resources

[Meta Argument Lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

## Terraform Data

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

[Terraform Data](https://developer.hashicorp.com/terraform/language/resources/terraform-data)

## Provisioners 

Provisioners allow you to execute commands on compute intances e.g. a AWS CLI command. 

They are not recommended for use by Hashicorp because configuration management tools such as Ansible are a better fir, but the functionality exists. 

[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Local-exec

This will execute a command on the machine runnig the terraform commands e.g. plan apply. 

```t
resource "aws_instance" "web" {

  provisioner "local-exec" {
    command    = "echo The server's IP address is ${self.private_ip}"
    on_failure = continue
  }
}
```

[Local](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)

### Remote-exec

This will execute commands on a machine which yu target. You will need to provide credentials such as ssh to get into the machine.

```t
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```
[Remote](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)

### For Each Expressions

let’s say you want to create multiple virtual machines with the same configuration. For cases like that, in Terraform you can use for_each

```sh
[for s in var.list :upper(s)]
```


[For Each Expressions Hashicorp Docs](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)


[For Each Expressions External Examples](https://thenewstack.io/how-to-use-terraforms-for_each-with-examples/)