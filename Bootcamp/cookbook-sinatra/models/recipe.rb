class Recipe
  attr_reader :name, :description, :prep_time, :is_done, :difficulty

  private

  attr_accessor

  public

  def initialize(name, description, prep_time, difficulty)
    @name = name
    @description = description
    @prep_time = prep_time
    @difficulty = difficulty
    @is_done = false
  end

  def done?
    is_done
  end

  def toggle_done
    self.is_done = !is_done
  end

  def to_csv
    [name, description, prep_time, difficulty, is_done]
  end
end

class Recipe
  def self.from_csv(array)
    recipe = Recipe.new(array[0], array[1], array[2], array[3].to_i)
    recipe.toggle_done if array [4] == "true"
    recipe
  end
end
