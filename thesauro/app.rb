#!/usr/bin/env ruby

require "net/http"
require "uri"
require "pry"
require "json"

API_KEY = "7c12a9f959a11b9e10c581cc977be5c5"

def flatten(hash_input)
  output = []
  hash_input.each do |key, value|
    case value
    when Hash
      output << flatten(value)
    else
      output << value
    end
  end
  output.flatten
end

def thesaurize(words, sentence)
  max_word = words.max_by { |word| word.length }
  max_word.gsub!(/[^a-zA-Z]/, "")
  uri = URI.parse("http://words.bighugelabs.com/api/2/#{API_KEY}/#{max_word}/json")
  response = Net::HTTP.get_response(uri)

  case response
  when Net::HTTPOK
    j = JSON.parse(response.body)
    thesaurus_entry = flatten(j)
    new_word = thesaurus_entry.max_by { |word| word.length }
    sentence.gsub!(max_word, new_word)
  #  words.length > 0
  else
    puts response.code
    if words.length > 0 && $tries > 0
      $tries -= 1
      words.delete(max_word)
      thesaurize(words, sentence)
    end
  end
end

system "clear"
puts "Enter your string to make fancy-talkin'"
loop do
  print "> "
  user_output = ""
  user_input = gets.chomp
  exit if user_input.strip == "exit"

  sentences = user_input.split(/[!?.]/)

  sentences.each do |sentence|
    $tries = 3
    words = sentence.split(/[ \-,;:]/)
    thesaurize(words, sentence)
    user_output << "#{sentence}. "
  end

  puts user_output
end
