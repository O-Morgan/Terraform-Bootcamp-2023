# Terraform Beginner Bootcamp 2023


## Semantic versioning
This project will utilise semantic versioning 



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
eg. `./bin/install_terraform_cli`
If we are using a script in .gitpod,yaml we need to point the script to a program to interpret it. 

eg, `source ./bin/install_terraform_cli`



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



### Github Lifecycle (Berfore, Init, Command)
We need to be careful when using the init because it will not re-run if we restart an existing workspace.

<div style="display: flex; justify-content: space-between;">
    <img src="image.png" alt="Alt text" style="width: 48%;">
    <img src="image-1.png" alt="Alt text" style="width: 48%;">
</div>






