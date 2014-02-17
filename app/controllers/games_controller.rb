class GamesController < ApplicationController
  before_filter :authenticate_user!

  # GET /games
  # GET /games.json
  def index
    @games = Game.available

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

    # Need to grab submissions corresponding to last round
    @winning_cards = @game.submissions.where(round: @game.round - 1)
    @winning_player = @winning_cards.first.user.email if @winning_cards.length > 0
    @submissions = Submission.where(game_id: @game.id).order(id: :asc)

    respond_to do |format|
      if @player and not @game.finished
        format.html # show.html.erb
        format.json {
          render json: {
            game: @game.as_json(only: [:finished, :round]),
            black_card: @game.black_card.as_json(only: :num_blanks, include: {content: {only: :text}}),
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
              cards: @winning_cards.as_json(include: {content: {only: :text}})
            }
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
