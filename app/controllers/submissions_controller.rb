class SubmissionsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def index
    @submissions = Submission.where(game_id: params[:game_id])

    render json: {
      submissions: @submissions,
      message: 'Submissions list for game',
      status: :ok
      }, status: :ok
  end

  def show
    @submission = Submission.find(params[:id])

    respond_with @submission
  end

  def create
    @submission = Submission.new
    @card = WhiteCard.find(params[:card_id])
    @hand = @card.hand

    if @card.hand.user.id == current_user.id and @hand.submissions_left > 0
      @submission.content = @card.content
      @submission.user_id = @hand.user.id
      @submission.game_id = @hand.game.id
    else
      render json: { message: 'You are not authorized to submit this card.', status: 401 }, status: 401
      return
    end

    if @submission.save && @card.destroy
      @hand.update_attributes(submissions_left: @hand.submissions_left - 1)
      render json: { 
        message: 'The submission was successfully saved.', 
        status: 200,
        submission: @submission
        }, status: :ok
    else
      render json: { 
        message: 'The submission could not be saved.', 
        status: :error
        },  status: :error
    end
  end
end
