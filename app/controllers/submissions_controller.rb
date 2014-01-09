class SubmissionsController < ApplicationController
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
end
