require 'open-uri'
require 'nokogiri'
require 'highline/import'
# Highline.colorize_strings

# http://tapastic.com/browse?browse=POPULAR&genreIds=<data-type of dropdown options>
GENRE_HASH = {
  '7': 'Action',
  '2': 'Comedy',
  '8': 'Drama',
  '3': 'Fantasy',
  '9': 'Gaming',
  '6': 'Horror',
  '5': 'Romance',
  '4': 'Sci-fi',
  '1': 'Slice of Life'
}
BASE_URL='http://tapastic.com/browse?browse=POPULAR&genreIds='
BASE_COMIC_URL = 'http://tapastic.com'
class Category
  attr_accessor :name, :url

  def initialize(opts={})
    @name = opts[:name]
    @url = opts[:url]
  end
end

class Comic
  attr_accessor :name, :url, :description, :follower_count, :view_count, :genre, :author

  def initialize(opts={})
    @name = opts[:name]
    @url = opts[:url]
    @description = opts[:description]
    @follower_count = opts[:follower_count]
    @view_count = opts[:view_count]
    @genre = opts[:genre]
    @author = opts[:author]
  end
end

class Bot
  categories = []
  comics = []
  doc = Nokogiri::HTML(open("http://tapastic.com/browse"))
  # puts doc.css("//nav/ul/li")
  # puts doc.css("dropdown")

  GENRE_HASH.each do |k,v|
    url = BASE_URL + k.to_s
    #doc = Nokogiri::HTML(open(url))
    categories << Category.new(name: v, url: url)
  end

  categories.each do |c|
    puts "Retrieving category info for #{c.name}"
    doc = Nokogiri::HTML(open(c.url))
    comic_nodes = doc.css('li.page-item-wrap.singular-item/a.title')

    comic_nodes.each do |comic_node|
        title = comic_node.text
        comic_path = comic_node['href']
        url = BASE_COMIC_URL + comic_path
        comics << Comic.new(genre: c.name, name: title, url: url)
    end

    sleep 0.5
  end

  comics.each do |c|
    puts "Retrieving comic info for #{c.name}"
    doc = Nokogiri::HTML(open(c.url))
    view_count_node = doc.css('span.cnt-txt')[0]
    view_count = view_count_node.text.strip

    follower_count_node = doc.css('span.cnt-txt')[1]
    follower_count = follower_count_node.text.strip

    description_node = doc.css('span#series-desc-body')[0]
    description = description_node.text.strip.gsub(/\s{2,}/,'')

    author_node = doc.css('span[@itemprop="name"]')[0]
    author = author_node.text.strip

    c.view_count = view_count
    c.follower_count = follower_count
    c.description = description
    c.author = author

    sleep 0.5
  end

  user_name = ask("What is your name?  ")
  user_food = ask("What is your favorite food?  ")

  puts "hello #{user_name}\n"

  loop do
    comics_matching_user_name = comics.select { |comic| comic.author =~ /user_name/ }
    if !comics_matching_user_name.empty?
      rand_comic_index = rand(comics_matching_user_name.length-1).to_i
      comic_choice = comics_matching_user_name[rand_comic_index]
      break
    end

    comics_with_food = comics.select { |comic| comic.description =~ /user_food/ }
    if !comics_with_food.empty?
      rand_comic_index = rand(comics_with_food.length-1).to_i
      comic_choice = comics_matching_user_name[rand_comic_index]
      break
    end

    user_genre = ask("What genre do you feel like reading? (#{GENRE_HASH.values.join(', ')})  ")

    comics_in_genre = comics.select { |comic| comic.genre == user_genre }
    rand_comic_index = rand(comics_in_genre.length-1).to_i
    comic_choice = comics_in_genre[rand_comic_index]

    puts "You might like #{comic_choice.name} by #{comic_choice.author}"
    puts ""
    puts "#{comic_choice.description}\n"
    puts "You can read it at #{comic_choice.url}"
  end

end
