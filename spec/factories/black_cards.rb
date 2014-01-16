FactoryGirl.define do
  factory :black_card do |f|
    f.num_blanks 1
    f.content "BLACK CARD CONTENT"
    f.deck_id 1
    f.game_id 1
  end
end
