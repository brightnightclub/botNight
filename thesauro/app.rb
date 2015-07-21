require "net/http"
require "uri"
require "pry"
require "json"

API_KEY = "53005dba943941efe2a387e3d5183401"

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

user_input = gets.chomp

sentences = user_input.split(/[!?.]/)

def thesaurize(words, sentence)
  max_word = words.max_by { |word| word.length }
  uri = URI.parse("http://words.bighugelabs.com/api/2/#{API_KEY}/#{max_word}/json")
  response = Net::HTTP.get_response(uri)
binding.pry
  case response
  when Net::HTTPOK
    j = JSON.parse(response.body)
    thesaurus_entry = flatten(j)
    new_word = thesaurus_entry.max_by { |word| word.length }
    sentence.gsub!(max_word, new_word)
  when words.length > 0
    words.delete(max_word)
    thesaurize(words, sentence)
  end
end

sentences.each do |sentence|
  words = sentence.split(/[ \-,;:]/)
  thesaurize(words, sentence)
  puts sentence
end
