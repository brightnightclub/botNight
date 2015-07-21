#!/bin/bash/ruby

# This is going to look at USDA API and look at calories

require 'httparty'
require 'pry'

foods = ["01001", "01002", "01008"]

response = HTTParty.get("http://api.nal.usda.gov/ndb/reports/?ndbno=#{foods.sample}&type=f&format=json&api_key=48GvBx3UTSMEOIuuDaDLplehUkyVGgVdA20FwPbb")

def find_cal(response)
  response['report']['food']['nutrients'].each do |nutrient|
    return nutrient['value'].to_i if (nutrient['unit'] == 'kcal')
  end
end

calories = find_cal(response)

name = response['report']['food']['name']

puts "How many calories are in #{name}?"

won = false

until won

  answer = gets.chomp.to_i

  if answer == calories
    won = true
  elsif answer < calories
    puts("too low!")
  elsif answer > calories
    puts("too high!")
  end

end

puts("Correct!! Goodbye.")
