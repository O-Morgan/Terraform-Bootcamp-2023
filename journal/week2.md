# Terraform Beginner Bootcamp 2023 week 2

## Working wit Ruby 

### Bundler 

Bundler is a package manager for Ruby, it is the primery way to install Ruby packages (known as gems) for Ruby 

#### Installing Gems 

you need to create a Gemfile and define your gems in that file

```rb
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```

Then you need to run the `bundle install` coommand

This will install the gems on the system globally (unlike nodejs which install packages in place, in a folder called node_modules)

A gem lock file will be created to lock down the gem versions used in this project, the gem lock files are created automatically by bundler the Ruby gem dependency management tool.

#### Executing Ruby scripts in the context of bundler 

We have to use `bundle exec` to tell future ruby scripts to use the gems we installed. This is the way we set context 

### Sinatra

Sinatra is a micro web-framework for Ruby to build web apps

It's great for mock or development servers or for very simple projects.

You can create a web-server in a single file.

[Sinatra](https://sinatrarb.com/)

## Terratowns Mock Server 

### Running the web server 

We can run the webserver by executing the following commands:

```rb
bundle install
bundle exec ruby server.rb
```
All of the code for our server is stored in the `server.rb` file