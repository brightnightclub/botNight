require_relative "constants"

puts "Hello Friend, how can I help?"

running = true

class ImposterBot
  def self.process(input)
    exit?(input)
    puts RESPONSES[sort_question(parse_input(input)).to_sym].sample
  end

  def self.parse_input(input)
    input.downcase.split " "
  end

  def self.sort_question(input)
    if find_match(input, YN)
      return "yn"
    elsif find_match(input, PERSONAL)
      return "personal"
    elsif find_match(input, CODING)
      return "coding"
    else
      return "comments"
    end
  end

  def self.exit?(input)
    if QUITTERS.include? input.downcase
      puts "Goodbye"
      exit
    end
  end

  def self.find_match(input_arr, type_arr)
    input_arr.each do |i|
      type_arr.each do |t|
        return true if i == t
      end
    end
    false
  end

end


while running do
  input = gets.chomp
  ImposterBot.process(input)
end
