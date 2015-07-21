QUITTERS = ["exit", "quit", "x", "q", "bye"]

puts "Hello Friend, how can I help?"

running = true

def process(input)
  if QUITTERS.include? input.downcase
    puts "Goodbye"
    exit
  end
  puts "Hhhhhhmmmmmm, interesting thought..."
end

while running do
  input = gets.chomp
  process(input)
end
