class HandsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @hand = Hand.where(game_id: params[:game_id], user_id: current_user.id).first

    render json: @hand.as_json(only: [:score, :submissions_left, :white_cards], include: [:white_cards => {only: :id, include: {content: {only: :text}}}])
  end

  def create
    @hand = Hand.new
    @hand.user = current_user
    @hand.game = Game.find(params[:game_id])

    respond_to do |format|
      if @hand.save
        @hand.game.new_round! if @hand.game.users.count == 2
        format.html { redirect_to @hand.game, notice: 'Welcome to the game!' }
        format.json { render json: @hand, status: :created, location: @hand }
      else
        format.html { render action: 'new' }
        format.json { render json: @hand.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @hand = Hand.where(game_id: params[:game_id], user_id: current_user.id).first
    @hand.destroy

    redirect_to games_path
  end
end
