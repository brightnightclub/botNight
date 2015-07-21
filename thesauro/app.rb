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

user_input = gets.chomp

sentences = user_input.split(/[!?.]/)

def thesaurize(words, sentence)
  max_word = words.max_by { |word| word.length }
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
    puts response
    if words.length > 0 && $tries > 0
      $tries -= 1
      words.delete(max_word)
      thesaurize(words, sentence)
    end
  end
end

sentences.each do |sentence|
  $tries = 3
  words = sentence.split(/[ \-,;:]/)
  thesaurize(words, sentence)
  puts sentence
end
