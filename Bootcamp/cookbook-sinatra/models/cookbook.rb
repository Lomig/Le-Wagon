# frozen_string_literal: true

require 'csv'
require_relative 'recipe'

class Cookbook
  private

  attr_accessor :recipes, :csv_file

  public

  def initialize(csv_file_path)
    @csv_file = csv_file_path
    @recipes = load_from_csv
  end

  def all
    recipes
  end

  def next_id
    recipes.length
  end

  def show_recipe(index)
    recipes[index]
  end

  def add_recipe(recipe)
    recipes << recipe
    save_to_csv
    self
  end

  def remove_recipe(recipe_index)
    recipes.delete_at(recipe_index)
    save_to_csv
    self
  end

  def find_by_id(recipe)
    recipes.index(recipe)
  end

  def destroy_all
    self.recipes = []
    save_to_csv
    self
  end

  def toggle_done(recipe_index)
    recipes[recipe_index].toggle_done
    save_to_csv
    self
  end

  private

  def load_from_csv
    csv_options = { col_sep: ',', quote_char: '"' }
    CSV.foreach(csv_file, csv_options).with_object([]) do |row, array|
      array << Recipe.from_csv(row)
    end
  end

  def save_to_csv
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    CSV.open(csv_file, 'wb', csv_options) do |csv|
      recipes.each do |recipe|
        csv << recipe.to_csv
      end
    end
  end
end
