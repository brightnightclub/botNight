#!/bin/bash/ruby

# This is going to ask the user about foods and caloric value

require 'httparty'
require 'pry'

response = HTTParty.get('api.nal.usda.gov/ndb/reports/' , :ndbno => "01009", :type => "f", :format => "json", :api_key => "DEMO_KEY")

puts "How many calories are in this food?"

binding.pry
