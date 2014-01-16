require 'spec_helper'

describe SubmissionsController do
  it "should give all submissions for a given game" do
    # post :create, submission: FactoryGirl.attributes_for(:submission), game_id: 1
    # response.should true
    get :index, game_id: 1, format: :json
    response.
  end
end
