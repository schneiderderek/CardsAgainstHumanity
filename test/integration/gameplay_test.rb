require 'test_helper'

class GameplayTest < ActionDispatch::IntegrationTest
  def login_user(user = users(:default))
    visit new_user_session_url

    within 'form#new_user' do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: '1234567890'
      click_on 'Sign in'
    end
  end

  test "After being logged in, you can view all games" do
    login_user
    visit games_url

    assert 200 == page.status_code
    assert has_link? 'Start a New Game', 'Should have a link to create a new game'
  end

  test "If not logged in, redirect to login page" do
    visit games_url

    assert 200 == page.status_code
    assert has_selector? 'body .container h2', text: 'Sign in'
  end

  teardown do
    visit root_url
    click_link 'Sign Out' if has_link? 'Sign Out'
  end
end
