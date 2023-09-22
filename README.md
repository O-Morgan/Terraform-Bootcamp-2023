# Terraform Beginner Bootcamp 2023


## Semantic versioning
This project will utilise semantic versioning i.e. 0.0.0 where the first digit is a **Major Change** and this resets the latter two digits back to zero when implimented, the second digit if for a **Minor Change** and the latter is for a **bug fix/patch.** 

[Semantic Versioning Documentation](https://semver.org/)



## Considerations with Terraform CLI Changes 
The Terraform CLI instructions have to change due to gpg keyring changes, so we needed to refer to the latest install CLI instructions via Terraform Documuntation and change the script for install.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) 



## Considerations for Linux Distribution
This project is built against ubuntu, please consider checking the Linux distribution and changing for your usecase and needs.

Example of checking OS Version:
```
$ cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```
[How to check OS Version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)



### Refactoring into Bash Scripts 
While fixing the Terraform CLI gpg depreciation issues, we noticed that the bash script steps had a considerably more code. We therefore decided to create a bash script to install the Terraform CLI.
The bash script is located here: [./bin/install_terraform_cli](./bin/install_terraform_cli)

Using a bin directory is a standard way of conduting business, which is explained in the Lamby Project.

[Lamby Project](https://lamby.cloud/docs/anatomy#architecture)



#### Shebang Considerations 
A Shebang tells the bash script what program will interpret the script. eg. `#!/bin/bash`

Chat GPT recommended this format for bash: `#!/usr/bin/env bash`

- For portability for different OS distributions 
- It will search the user's PATH for the bash executable 

when executing a bash script we can use the `./` shorthand notation to execute the bash script.

[Shebang wiki link](https://en.wikipedia.org/wiki/Shebang_(Unix))



#### Execution Considerations 
e.g. `./bin/install_terraform_cli`
If we are using a script in .gitpod,yaml we need to point the script to a program to interpret it. 

e.g. `source ./bin/install_terraform_cli`



#### Linux Permission Considerations 
In order to make our bash scripts executable we need to change linux permissions for the fix to be executable at the user mode.

```sh
chmod u=x ./bin/install_terraform_cli
```
alternatively 

```sh
chmod 744 ./bin/install_terraform_cli
```
[Chmod wiki link](https://en.wikipedia.org/wiki/Chmod)



## Github Lifecycle (Before, Init, Command)
We need to be careful when using the init because it will not re-run if we restart an existing workspace.

[Gitpod Documentation](https://www.gitpod.io/docs/configure/workspaces/tasks)




## Working Env Vars

### Env Command 

We can list out all enviroment variables (Env Vars) using the `env` command. 

The grep command is a very useful linux command allowing you to filter quickly to specific Env Vars `env | grep AWS_ ` 

#### Setting and Unsetting Env Vars 

In the terminal we can set using `export Hello=world`

in the terminal we can unset using `unset Hello`

We can set an Env Var temporarily when just running a command.

```sh
Hello=`world` ./bin/print_message
```
Within a bash script we can set an Env Var without writing export e.g.

```sh
#!/usr/bin/env bash

Hello=`world`

echo $Hello
```
#### Printing Vars

You can print an Env Var using echo e.g. `echo $Hello`

#### Scoping of Env Vars 
When you open up new bash terminals in VSCode it will not be aware of Env Vars that you have set in another window, if you want Env Vars to persist across all future bash terminals that are open you need to set the Env Vars in your bash profile. e.g. `bash_profile` 

#### Persisting Env Vars in gitpod 

We can persist Env Vars into gitpod by storing them in Gitpod Secrets Storage.

```
gp env Hello=world 
```
All future workspaces launched will set the env vars for all bash terminals opened in those workspaces.

You can also set Env Vars in the `.gitpod.yaml` but this can only contain non-sensitive Env Vars.


## AWS CLI Installation for this project 

AWS CLI is installed for the project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

:warning: Don't install via Homebrew :ambulance::roller_coaster:

:rotating_light: We can check if our AWS credentials are configured correctly by running the following AWS CLI command. 
```sh
aws sts get-caller-id
```
If successful, a json payload should be rerturned that looks like this. 

```JSON
{
    "UserId": "AIDA7RRCITNEJHVPKPEWS",
    "Account": "979354389342",
    "Arn": "arn:aws:iam::199758341882:user/Owen"
}
```

We will need to generate AWS credentials in order to use the AWS CLI.

## Terraform Basics

### Terraform Registry 

Terraform sources their providers and modules from the terraform regesitry which is located at [regitry.terraform.io](https://registry.terraform.io/)

**Terraform providers** are plugins or extensions in the Terraform infrastructure-as-code (IAC) tool that enable communication with external APIs and services. They act as connectors between Terraform and various cloud providers, infrastructure platforms, and services, allowing Terraform to provision and manage resources in those environments.

**Modules** are a fundamental concept in Terraform that promotes code reuse, maintainability, and collaboration in your infrastructure-as-code (IAC) projects.

### Terraform cnsole 

Typing `terraform` displays a list of all terraform commands.

### Terraform Init

The terraform command run to initialise the project is `terraform init` which downloads the binaries for the terraform providers that will be used in this project. 

#### Terraform Plan

Execute the `terraform plan` command in your project directory. Terraform will analyse your configuration files, compare them to the current state of your infrastructure (which it tracks in a state file), and determine the actions required to bring your infrastructure into alignment with the configuration.

Terraform will display a summary of the changes it plans to make, including resource creation, modification, or deletion.
It will also identify any variables or data sources used in the configuration.
The command will output a detailed execution plan, showing you what Terraform intends to do, such as creating or updating specific resources.

#### Terraform Apply

`terraform apply` is a command in Terraform, an infrastructure-as-code (IAC) tool, that is used to apply the changes defined in your Terraform configuration to your infrastructure. It is typically the command you use after running terraform plan and reviewing the execution plan to ensure that Terraform makes the desired changes to your infrastructure resources.

### Terraform Lock Files
`terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project, the terraform lock file should be committed to the **Version Control System** (VSC) e.g. GitHub. 

### Terraform state Files 
Terraform uses a state file (usually named `terraform.tfstate`) to keep track of the current state of your infrastructure. While not a lock file, it serves as a record of your deployed resources and their properties. It's important to manage and lock this state file when collaborating with others.

### Terraform Directory
`terraform` dierctory contains binaries of terraform providers. 