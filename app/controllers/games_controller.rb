require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    # display a new random grid and form
    # submit form with POST to score the action
    letters_array = ('A'..'Z').to_a
    @letters = []
    10.times { @letters << letters_array.sample }
    @letters
    @start_time = Time.now.to_i
  end

  def in_grid?(attempt, grid)
    attempt.each_char.all? { |letter| attempt.count(letter) <= grid.downcase.count(letter) }
  end

  def score
    # generate score/message
    @attempt = params[:attempt]
    @letters = params[:letters]
    @start_time = params[:start_time].to_i
    @end_time = Time.now.to_i

    @result = {}
    @result[:time] = (@end_time - @start_time)


    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    word_serialised = URI.open(url).read
    word = JSON.parse(word_serialised)

    if word['found'] == false
      @result[:message] = 'Your word is not an English word'
      @result[:score] = 0
    elsif in_grid?(@attempt, @letters)
      @result[:message] = 'Well done!!'
      @result[:score] = (@result[:time] * -1) + (@attempt.length * 100)
    else
      @result[:message] = 'Your word is not in the grid'
      @result[:score] = 0
    end
    @result
  end
end
