require 'sinatra'
require 'json'
require 'pry'
require 'active_model'

# we will mock a stae of database for thsi development server by setting a global varaible
# you would never use a global variable in a production server 
#$ means global in Ruby and some othe rlanguages but not all.
$home = {}

# This is a ruby class that includes validations for ActiveRecord.
# This will represent our Home resource as a Ruby object. 
class Home
# ActiveModel is part of Ruby Rails.
# It is used as an ORM. It has a module within ActiveModel that provides validations.
# The product Terratowns server is rails and uses very similar and in most cases identical validation
# https://guides.rubyonrails.org/active_model_basics.html
# https://guides.rubyonrails.org/active_record_validations.html
  include ActiveModel::Validations

# create some virtual attributes to be stored on this object 
# This will set a getter and setter
# e.g.
# home.town = 'hello' # setter 
  attr_accessor :town, :name, :description, :domain_name, :content_version
# gamers-groto
# cooker-cove
  validates :town, presence: true, inclusion: { in: [
    'melomaniac-mansion',
    'cooker-cove',
    'video-valley',
    'the-nomad-pad',
    'gamers-grotto'
  ] }
# visible to all users
  validates :town, presence: true
# visible to all users 
  validates :name, presence: true
# visible to all users
  validates :description, presence: true
# we want to lock this down to only be from cloudfront 
  validates :domain_name, format: { with: /.+\.cloudfront\.net\z/, message: "domain must be from .cloudfront.net" }
# uniqueness: true, 

# content version has to be an interger
# we will it is an incremental version in the controller 
  validates :content_version, numericality: { only_integer: true }
end

# we are extending a class from Sinatra Base
# turn this generic class to utilise the utilise the Sinatra Base 
class TerraTownsMockServer < Sinatra::Base

  def error code, message
    halt code, {'Content-Type' => 'application/json'}, {err: message}.to_json
  end

  def error_json json
    halt code, {'Content-Type' => 'application/json'}, json
  end

  def ensure_correct_headings
    unless request.env["CONTENT_TYPE"] == "application/json"
      error 415, "expected Content_type header to be application/json"
    end

    unless request.env["HTTP_ACCEPT"] == "application/json"
      error 406, "expected Accept header to be application/json"
    end
  end

  # return a hardcoded access token - database simulation
  def x_access_code
    '9b49b3fb-b8e9-483c-b703-97ba88eef8e0'
  end

  def x_user_uuid
    'e328f4ab-b99f-421c-84c9-4ccea042c7d1'
  end

  def find_user_by_bearer_token
    # https://swagger.io/docs/specification/authentication/bearer-authentication/
    auth_header = request.env["HTTP_AUTHORIZATION"]
    # Check if Authorisation header exists? 
    if auth_header.nil? || !auth_header.start_with?("Bearer ")
      error 401, "a1000 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

    # Does the token match the one in our database?
    # if we cant find it then return an error or if it doesn't match
    # code = access_code = token
    code = auth_header.split("Bearer ")[1]
    if code != x_access_code
      error 401, "a1001 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

    if params['user_uuid'].nil?
      error 401, "a1002 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

    unless code == x_access_code && params['user_uuid'] == x_user_uuid
      error 401, "a1003 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end
  end

  # CREATE
  post '/api/u/:user_uuid/homes' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# create - POST /api/homes"

    # A begin/resource is a try/catch, if an error occurs, result it
    begin
      # Sinatra does not automatically part json bodys as params
      # Like rails so we manually need to parse it. 
      payload = JSON.parse(request.body.read)
    rescue JSON::ParserError
      halt 422, "Malformed JSON"
    end

    # Validate payload data to make it easier to work with the code
    name = payload["name"]
    description = payload["description"]
    domain_name = payload["domain_name"] # Add this line to extract domain_name
    content_version = payload["content_version"]
    town = payload["town"]
    

# Now you can use all these variables in your code

    # printing the variables out to console to make it easier to see or debug what we have input into this endpoint
    puts "name #{name}"
    puts "description #{description}"
    puts "domain_name #{domain_name}"
    puts "content_version #{content_version}"
    puts "town #{town}"

    # Create a new Home model and set to attributes 
    home = Home.new
    home.town = town
    home.name = name
    home.description = description
    home.domain_name = domain_name
    home.content_version = content_version
    
    # Ensure our validation checks are passed otherwise return a error 
    unless home.valid?
      error 422, home.errors.messages.to_json
    end

    # Generating a uuid at random
    uuid = SecureRandom.uuid
    puts "uuid #{uuid}"
    # Will mock our data to our mock database which is just a global variable 
    $home = {
      uuid: uuid,
      name: name,
      town: town,
      description: description,
      domain_name: domain_name,
      content_version: content_version
    }
    # Will just return the uuid
    return { uuid: uuid }.to_json
  end

  # READ
  get '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# read - GET /api/homes/:uuid"

    # checks for house limit

    content_type :json
    # Does the uuid for the home match the one in our database?
    if params[:uuid] == $home[:uuid]
      return $home.to_json
    else
      error 404, "failed to find home with provided uuid and bearer token"
    end
  end

  # UPDATE
  # Very similar to the create action
  put '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# update - PUT /api/homes/:uuid"
    begin
      # Parse JSON payload from the request body
      payload = JSON.parse(request.body.read)
    rescue JSON::ParserError
      halt 422, "Malformed JSON"
    end

    # Validate payload data
    name = payload["name"]
    description = payload["description"]
    content_version = payload["content_version"]

    unless params[:uuid] == $home[:uuid]
      error 404, "failed to find home with provided uuid and bearer token"
    end

    home = Home.new
    home.town = $home[:town]
    home.domain_name = $home[:domain_name]
    home.name = name
    home.description = description
    home.content_version = content_version

    unless home.valid?
      error 422, home.errors.messages.to_json
    end

    return { uuid: params[:uuid] }.to_json
  end

  # DELETE
  delete '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# delete - DELETE /api/homes/:uuid"
    content_type :json

    if params[:uuid] != $home[:uuid]
      error 404, "failed to find home with provided uuid and bearer token"
    end

    # delete from our mock database
    uuid = $home[:uuid]
    $home = {}
    { uuid: uuid }.to_json
  end
end

# This is what will run the server 
TerraTownsMockServer.run!