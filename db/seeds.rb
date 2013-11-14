# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create a Default deck
d = Deck.create(name: :Default, game: nil)

# Create all white cards associated with this deck
File.read("#{Dir.pwd}/db/seed_files/white_cards.txt").split(/[\n]/).each do |x|
  WhiteCard.create(content: x.strip, deck: d)
end

# Create all black cards associated with the default deck
File.read("#{Dir.pwd}/db/seed_files/black_cards.txt").split(/[\n]/).each do |x|
  BlackCard.create(content: x, deck: d)
end
