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
WhiteCard.create(content: "White Card 1", deck: d)
WhiteCard.create(content: "White Card 2", deck: d)

# Create all black cards associated with the default deck
BlackCard.create(content: "Black Card 1", deck: d)
BlackCard.create(content: "Black Card 2", deck: d)