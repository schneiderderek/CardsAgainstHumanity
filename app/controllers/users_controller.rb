class UsersController < ApplicationController
  def index
    @users = User.where(game: params[:game_id])
    
    respond_to do |format|
      format.html
      format.json { render json: @users}
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @user}
    end
  end
end
