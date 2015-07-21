require "markov_chains"
require "io/console"

text = open("book.txt").read

generator = MarkovChains::Generator.new(text)

puts "It's perhaps fitting that I write this introduction in jail- that graduate school of survival."

#This puts it into a raw mode and removes the part where you see what you're typing
def read_char()
  STDIN.getch()
end

def print_char(char)
  print char
  STDOUT.sync
end

interrupt = rand(20)+5
char_counter = 0

loop do
  newChar = read_char()
  char_counter += 1
  if newChar == "\u0003"
    break
  end

  if newChar == "\r"
    char_counter = interrupt
  end

  print_char(newChar)

  if char_counter == interrupt
    print "--" unless newChar == "\r"
    puts
    puts generator.get_sentences(1)
    char_counter = 0
    interrupt = rand(20)+5
  end
end
