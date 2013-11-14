class HandsController < ApplicationController
  def index
    @hands = Hand.where(game_id: params[:game_id], user_id: params[:user_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hands }
    end
  end

  def show
    @hand = Hand.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hand }
    end
  end

  def new
    @hand = Hand.new
    @game = Game.find(params[:game_id])
    @user = User.find(params[:user_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hand }
    end
  end

  def create
    @hand = Hand.new
    @hand.user = User.find(params[:user_id])
    @hand.game = Game.find(params[:game_id])

    respond_to do |format|
      if @hand.save
        format.html { redirect_to @hand.game, notice: 'Welcome to the game!' }
        format.json { render json: @hand, status: :created, location: @hand }
      else
        format.html { render action: "new" }
        format.json { render json: @hand.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @hand = Hand.find(params[:id])

    respond_to do |format|
      if @hand.update_attributes(params[:hand])
        format.html { redirect_to @hand, notice: 'Hand was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hand.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @hand = Hand.find(params[:id])
    @hand.destroy

    respond_to do |format|
      format.html { redirect_to hands_url }
      format.json { head :no_content }
    end
  end
end
