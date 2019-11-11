# frozen_string_literal: true

# Missing top-level class documentation comment.
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.chars.count(letter) <= grid.chars.count(letter) }
  end

  def compute_score(attempt)
    attempt.size * 1.0
  end

  # def run_game(attempt, grid)
  #   score_and_message = score_and_message(attempt, grid)
  #   result[:score] = score_and_message.first
  #   result[:message] = score_and_message.last
  #   result
  # end

  def score
    # raise
    # binding.pry
    @lettres = params[:grid]
    @attempt = params[:games]
    if included?(@attempt.upcase, @lettres)
      if english_word?(@attempt)
        @score = compute_score(@attempt)
        @result = [@score, "Congrats! #{@attempt} is a valid English word"]
      else
        @result = [0, "Sorry, but #{@attempt} isn't a valid English word"]
      end
    else
      @result = [0, "Sorry, but #{@attempt} can't be build out of #{@lettres}"]
    end
  end

  def english_word?(word)
    @response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    @json = JSON.parse(@response.read)
    @json['found']
  end
end
