# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

##
# Class used to parse Marmiton recipes
# We want to let the user select his prefered ones for his cookbook
class MarmitonParsingService
  private

  attr_reader :full_recipe_document
  attr_accessor :url, :document

  public

  def initialize(url)
    @url = 'https://www.marmiton.org/recettes/recherche.aspx?aqt=' + url
    @document = Nokogiri::HTML(open(@url), nil, 'utf8')
  end

  def parse_title(number_of_element)
    document.search("//h4[@class='recipe-card__title']").map { |match| match.text }[0...number_of_element]
  end

  def parse_description(index)
    full_recipe_url = "https://www.marmiton.org" + document.search("//a[@class='recipe-card-link']")[index]["href"]
    @full_recipe_document = Nokogiri::HTML(open(full_recipe_url), nil, 'utf8')

    full_recipe_document.search("//ol[@class='recipe-preparation__list']").text.strip
  end

  def parse_prep_time
    return "" unless full_recipe_document

    full_recipe_document.search("//div[contains(@class, 'recipe-infos__timmings__total-time')]/span").text.strip
  end

  def parse_difficulty
    return 0 unless full_recipe_document

    full_recipe_document.search("//div[contains(@class, 'recipe-infos__level__container')]")[0]["class"][-1].to_i
  end
end
