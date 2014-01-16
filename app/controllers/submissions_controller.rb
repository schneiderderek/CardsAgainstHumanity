class SubmissionsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def index
    @submissions = Submission.where(game_id: params[:game_id])

    respond_with @submissions
  end

  def show
    @submission = Submission.find(params[:id])

    respond_with @submission
  end

  def create
    @submission = Submission.new
    @card = WhiteCard.find(params[:card_id])

    if @card.hand.user.id == current_user.id
      @submission.content = @card.content
      @submission.user_id = @card.hand.user.id
      @submission.game_id = @card.hand.game
    else
      render json: {}, status: :error
      return
    end

    respond_to do |format|
      if @submission.save && @card.destroy
        render json: {}, status: :ok
      else
        render json: {}, status: :error
      end
    end
  end
end
