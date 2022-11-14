require 'json'
require 'open-uri'

class GamesController < ApplicationController
  VOWELS = %w[A E I O U].freeze
  def new
    @letters = []
    i = rand(3..4)
    i.times { @letters << VOWELS.sample }
    (10 - i).times { @letters << (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @result = if check_grid && fetch_api(@word)
                'valid'
              elsif check_grid
                'invalid'
              else
                'error'
              end
  end

  private

  def fetch_api(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    raw = URI.open(url).read
    parsed = JSON.parse(raw)
    parsed['found']
  end

  def check_grid
    word_count = @word.upcase.chars.tally
    letters_count = @letters.split.tally
    word_count.keys.all? do |key|
      word_count[key] <= letters_count[key] unless letters_count[key].nil?
    end
  end
end
