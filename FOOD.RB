#!/bin/bash/ruby

# This is going to look at USDA API and look at calories

require 'httparty'
require 'pry'
require 'environment.rb'

foods = [21228, 21232, 21233, 21234, 21235, 21237, 21238, 21309, 21310, 21311, 21313, 21314, 21315, 21316, 21319, 21321, 21324, 21327, 21328, 21329, 21333, 21334, 21335, 21336, 21337, 21338, 21339, 21340, 21341, 21344, 21345, 21346, 21347, 21348, 21349, 21350, 21355, 21356 , 21357, 21358, 21359, 21360, 21361, 21362, 21363, 21364, 21365, 21376, 21377, 21378, 21379, 21380, 21381, 21402, 21403, 21404, 21405, 21406, 21407]

response = HTTParty.get("http://api.nal.usda.gov/ndb/reports/?ndbno=#{foods.sample.to_s}&type=f&format=json&api_key=48GvBx3UTSMEOIuuDaDLplehUkyVGgVdA20FwPbb")

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
