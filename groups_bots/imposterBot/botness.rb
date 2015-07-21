QUITTERS = ["exit", "quit", "x", "q", "bye"]
RESPONSES = {
  "yn": [],
  "personal": [],
  "coding": [],
  "comments": []
}

YN = ["or", "yes", "no", "either", "do", "does"]
PERSONAL = ["you", "u", "your", "u're", "you're", "ur", "bot", "bots", "imposterbot", "robot",
   "robots", "prefer", "preference", "like", "dislike"]
CODING = ["ruby", "python", "javascript", "oop", "debug", "code", "coding", "computer", "mac",
  "terminal", "sublime", "framework", "rails", "developer", "development", "stuck", "problem", "stack overflow", "google"]

puts "Hello Friend, how can I help?"

running = true



class ImposterBot
  def self.process(input)
    if QUITTERS.include? input.downcase
      puts "Goodbye"
      exit
    end

    puts "Hhhhhhmmmmmm, interesting thought..."
  end

  def self.sort_question(input)
    input = input.downcase

    if YN.include? input
      q_type = "yn"
    elsif PERSONAL.include? input
      q_type = "personal"
    elsif CODING.include? input
      q_type = "coding"
    else
      q_type = "comments"
    end
  end

end


while running do
  input = gets.chomp
  ImposterBot.process(input)
end
