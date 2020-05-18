require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = (0..9).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    @word = params[:word]
    @result = run_game(@word, @grid)
  end

  def run_game(word, grid)
    if !in_grid?(word, grid)
      @score = "Sorry but #{word} can't be built out of #{grid}."
    elsif !english_word?(word)
      @score = "Sorry but #{word} does not seem to be a valid English word..."
    elsif in_grid?(word, grid) && english_word(word)
      @score = "Congratulations! #{word} is a valid word!"
    end
  end

  private

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word.downcase}"
    serialized_word = open(url).read
    word_check = JSON.parse(serialized_word)
    return word_check['found']
  end

  def in_grid?(word, grid)
    word.chars.sort.all? { |letter| grid.include?(letter) }
  end
end
