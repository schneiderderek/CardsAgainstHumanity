class SubmissionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @submissions = Submission.where(game_id: params[:game_id])

    respond_to do |format|
      format.json { render json: @submissions }
    end
  end

  def show
    @submission = Submission.find(params[:id])

    respond_to do |format|
      format.json { render json: @submission }
    end
  end

  def create
    @submission = Submission.new(params[:submission])

    respond_to do |format|
      if @submission.save
        format.json { render json: {}, status: :ok }
      else
        format.json { render json: {}, status: :unprocessable_entity }
      end
    end
  end

  def submit
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
        format.json { render json: {}, status: :ok }
      else
        format.json { render json: {}, status: :ok }
      end
    end
  end
end
