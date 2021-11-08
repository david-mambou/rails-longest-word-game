require 'open-uri'

class GamesController < ApplicationController
  attr_reader :letters

  def new
    @letters = Array.new(10) { Array('A'..'Z').sample }
  end

  def score
    cookies[:score] = cookies[:score] ? cookies[:score].to_i : 0
    answer = params[:answer].upcase
    @result = if not_in_the_grid?(answer)
                "Sorry, you cannot build #{answer} with letters #{params[:letters]}."
              elsif not_english_word?(answer)
                "Sorry, you can build #{answer} with letters #{params[:letters]} but it ain't proper English."
              else
                cookies[:score] += calculate_score(answer)
                "Congratulations! You earn #{calculate_score(answer)} points. Total: #{cookies[:score]}"
              end
  end

  private

  def not_english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    page = URI.open(url).read
    result = JSON.parse(page)
    result['found'] ? false : true
  end

  def not_in_the_grid?(word)
    grid = params[:letters].chars
    word.chars.each do |letter|
      return true unless grid.index(letter)

      grid.delete_at(grid.index(letter))
    end
    false
  end

  def calculate_score(word)
    word.length
  end
end
