class GamesController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /games
  # GET /games.json
  def index
    @games = Game.all.keep_if { |x| !x.finished }

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
    @czar_user = @game.czar
    @player = @game.hands.where(user_id: current_user.id).first
    @white_cards = @player.white_cards if @player and !@czar
    @winning_card = WhiteCard.find(@game.winning_card_id).content if @game.winning_card_id
    @winning_player = User.find(WhiteCard.find(@game.winning_card_id).user_id).email if @game.winning_card_id
    @submissions = Submission.where(game_id: @game.id).order(id: :asc)

    respond_to do |format|
      if @player
        format.html # show.html.erb
        format.json {
          render json: {
            game: @game.as_json(only: [:finished]), 
            black_card: @game.black_card.as_json(only: [:num_blanks, :content]),
            game_hand: @game.submissions.as_json(only: [:content, :user_id, :id]),
            player_hand: @white_cards.as_json(only: [:content, :id]),
            player: @player,
            players: @game.users.collect { |u|
              { email: u.email, submissions_left: u.hands.where(game_id: params[:id]).first.submissions_left }
            }.as_json,
            czar: {
              email: @czar_user.email,
              self: @czar
            },
            winner: {
              email: @winning_player,
              content: @winning_card
            },
            submissions: @submissions
          }
        }
      else
        format.html { redirect_to games_path }
        format.json { render json: { message: 'You have not joined this game' }, status: :error }
      end
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

    if czar = (current_user.id == @game.czar_id)
      @card.hand.update_attributes(score: @card.hand.score + 1)
      @game.update_attributes(winning_card_id: @card.id)
      @card.update_attributes(hand_id: nil)
    elsif @card.hand.submissions_left > 0
      @card.hand.update_attributes(submissions_left: @card.hand.submissions_left - 1)
      @submission = Submission.new(user_id: current_user.id, 
                                  game_id: @game.id, content: @card.content)
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
          format.json do 
            render json: { message: 'There was an issue starting a new round.' }, status: :error
          end
        end
      else
        if @submission.save
          format.json { render json: {}, status: :ok }
        else
          format.json do 
            render json: { message: 'There was an issue saving your submitted card' }, status: :error
          end
        end
      end
    end unless @game.finished
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

  def self.operation_destroy
    Game.all.each { |g| g.destroy if ((Time.zone.now - g.updated_at).to_i / 1.day >= 14) || g.finished }
  end
end
