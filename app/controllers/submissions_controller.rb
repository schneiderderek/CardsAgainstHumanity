class SubmissionsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def index
    @game = Game.find(params[:game_id])
    @submissions = @game.submissions.where(round: @game.round).order(id: :asc)

    render json: {
      submissions: @submissions.as_json(only: :id, include: {content: {only: :text}}),
      players: @game.users.collect { |u|
              { email: u.email, submissions_left: u.hands.where(game_id: params[:game_id]).first.submissions_left }
            }.as_json,
      czar: current_user.id == @game.czar_id,
      round: @game.round,
      message: 'Submissions list for game',
      status: :ok
      }, status: :ok
  end

  def show
    @submission = Submission.find(params[:id])

    respond_with @submission
  end

  # POST
  def submit
    @submission = Submission.find(params[:id])
    @game = @submission.game
    @hand = @submission.hand

    if current_user.id == @game.czar_id
      @hand.update_attributes(score: @hand.score + 1)

      unless @game.finished
        @game.new_round!
        render json: {}, status: :ok
      end
    else
      render json: {
        message: 'You are not the card czar',
        status: 401
        }, status: 401
    end
  end

  def create
    @submission = Submission.new
    @card = WhiteCard.find(params[:card_id])
    @hand = @card.hand

    if @hand.user.id == current_user.id and @hand.submissions_left > 0
      @submission.content = @card.content
      @submission.hand_id = @hand.id
      @submission.game_id = @hand.game.id
      @submission.round = @hand.game.round
    else
      render json: {
        message: 'You are not authorized to submit this card.',
        status: 401
        }, status: 401
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
