# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"

require_relative "./models/recipe"
require_relative "./models/cookbook"
require_relative "./services/marmiton_parsing_service"

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__dir__)
end

cookbook = Cookbook.new("./data/recipes.csv")
search = nil

get '/' do
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :create
end

get '/delete/:recipe_id' do
  cookbook.remove_recipe(params[:recipe_id].to_i)
  redirect("/")
end

post '/recipes' do
  cookbook.add_recipe(Recipe.new(params[:recipe_name],
                                 params[:recipe_description],
                                 params[:recipe_prep_time],
                                 params[:recipe_difficulty]))
  redirect("/")
end

get '/recipe/:recipe_id' do
  @recipe = cookbook.show_recipe(params[:recipe_id].to_i)
  erb :display
end

get '/import' do
  erb :import
end

post '/import' do
  @keyword = params[:recipe_search]
  search = MarmitonParsingService.new(@keyword)
  @results = search.parse_title(5)
  erb :import
end

get '/import/:index/:name' do
  description = search.parse_description(params[:index].to_i)
                      .gsub(/^\s+/, "")
                      .gsub(/\t+/, "<br>")
  prep_time = search.parse_prep_time
  difficulty = search.parse_difficulty
  cookbook.add_recipe(Recipe.new(params[:name],
                                 description,
                                 prep_time,
                                 difficulty))
  redirect("/")
end
