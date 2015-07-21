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
  return if words.empty?

  max_word = words.sample
  max_word.gsub!(/[^a-zA-Z]/, "")
  uri = URI.parse("http://words.bighugelabs.com/api/2/#{API_KEY}/#{max_word}/json")
  puts uri
  response = Net::HTTP.get_response(uri)

  case response
  when Net::HTTPOK
    j = JSON.parse(response.body)
    thesaurus_entry = flatten(j)
    new_word = thesaurus_entry.max_by { |word| word.length }
    puts new_word
    sentence.gsub!(/\b#{max_word}\b/, new_word)
  #  words.length > 0
  else
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
    iterations = (words.length / 5) + 1
    iterations.times do
      thesaurize(words, sentence)
    end
    user_output << "#{sentence}. "
  end

  puts user_output
end
