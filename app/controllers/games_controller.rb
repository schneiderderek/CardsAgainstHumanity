class GamesController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /games
  # GET /games.json
  def index
    @games = Game.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])
    @czar = current_user.id == @game.czar_id
    @czar_user = User.find(@game.czar_id)

    if @czar
      @white_cards = @game.hands.where(user_id: nil).first.white_cards
    else
      @white_cards = @game.hands.where(user_id: current_user.id).first.white_cards
    end

    @player = @game.hands.where(user_id: current_user.id).first

    respond_to do |format|
      format.html # show.html.erb
      format.json {
        render json: {
          game: @game, 
          black_card: @game.black_card.as_json(only: [:num_blanks, :content]),
          game_hand: @game.hands.where(user_id: nil).first.white_cards.order('user_id ASC').as_json(only: [:content, :user_id]),
          player_hand: @white_cards.as_json(only: [:content, :id]),
          player: @player,
          czar: {
            email: @czar_user.email,
            self: @czar
          }
        }
      }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # POST
  def hand
    @game = Game.find(params[:id])
    @card = WhiteCard.find(params[:card_id])
    czar = current_user.id == @game.czar_id

    if czar
      @user_hand = @card.user.hands.where(game_id: @game.id).first
      @user_hand.score += 1
    elsif @card.hand.submissions_left > 0
      @user_hand = @card.hand
      @card.hand = @game.hands.where(user_id: nil).first
      @user_hand.submissions_left -= 1
    else
      render json: {}, status: :unprocessable_entity
      return
    end
    
    respond_to do |format|
      if czar
        if @user_hand.save
          @game.new_round!
          format.json { render json: {}, status: :ok }
        else
          format.json { render json: {}, status: :unprocessable_entity }
        end
      else
        if @card.save && @user_hand.save
          format.json { render json: {}, status: :ok }
        else
          format.json { render json: {}, status: :unprocessable_entity }          
        end
      end
    end
  end

  # POST /games
  # POST /games.json
  def create
    deck = Deck.find(params[:game].delete(:deck))
    @game = Game.new(params[:game])
    @game.original_deck_id = deck.id
    @game.deck = deck.dup
    @game.czar_id = current_user.id

    Hand.create(game: @game, user: current_user)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def operation_destroy
    Game.all.each { |g| g.destroy if (Time.zone.now - g.updated_at).to_i / 1.day >= 14 }
  end

end
