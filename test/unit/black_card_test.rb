require 'test_helper'

class BlackCardTest < ActiveSupport::TestCase
  test 'num blanks set correctly for _' do
    b = BlackCard.create(content: 'One blank space _')
    assert_equal 1, b.num_blanks
    assert_equal 'One blank space _', b.content
  end

  test 'num blanks set correctly for _ _' do
    b = BlackCard.create(content: 'Two _ blank spaces _')
    assert_equal 2, b.num_blanks
    assert_equal 'Two _ blank spaces _', b.content
  end

  test 'num blanks set correctly for _ _ _' do
    b = BlackCard.create(content: 'Three _ blank _ spaces _')
    assert_equal 3, b.num_blanks
    assert_equal 'Three _ blank _ spaces _', b.content
  end

  test 'num blanks set correctly for __' do
    b = BlackCard.create(content: 'ONE __ BLANK SPACE')
    assert_equal 1, b.num_blanks
    assert_equal 'ONE __ BLANK SPACE', b.content
  end

  test 'num blanks set correctly for' do
    b = BlackCard.create(content: 'ONE BLANK')
    assert_equal 1, b.num_blanks
    assert_equal 'ONE BLANK', b.content
  end

  # test 'multiple ____ condensed to _' do
  #   b = BlackCard.create(content: '_______')
  #   assert_equal 1, b.num_blanks
  #   assert_equal '_', b.content
  # end
end
  