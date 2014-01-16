class SubmissionsController < ApplicationController
  # before_filter :authenticate_user!
  skip_before_filter  :verify_authenticity_token
  respond_to :json

  def index
    @submissions = Submission.where(game_id: params[:game_id])

    # respond_with @submissions

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

    if true || @card.hand.user.id == current_user.id
      @submission.content = @card.content
      @submission.user_id = @card.hand.user.id
      @submission.game_id = @card.hand.game.game_id
    else
      render json: { message: 'You are not authorized to submit this card.', status: 401 }, status: 401
      return
    end

    if @submission.save && @card.destroy
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
