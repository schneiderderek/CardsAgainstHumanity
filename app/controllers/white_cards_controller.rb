class WhiteCardsController < ApplicationController
  # GET /white_cards
  # GET /white_cards.json
  def index
    @white_cards = WhiteCard.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @white_cards }
    end
  end

  # GET /white_cards/1
  # GET /white_cards/1.json
  def show
    @white_card = WhiteCard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @white_card }
    end
  end

  # GET /white_cards/new
  # GET /white_cards/new.json
  def new
    @white_card = WhiteCard.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @white_card }
    end
  end

  # GET /white_cards/1/edit
  def edit
    @white_card = WhiteCard.find(params[:id])
  end

  # POST /white_cards
  # POST /white_cards.json
  def create
    @white_card = WhiteCard.new(params[:white_card])

    respond_to do |format|
      if @white_card.save
        format.html { redirect_to @white_card, notice: 'White card was successfully created.' }
        format.json { render json: @white_card, status: :created, location: @white_card }
      else
        format.html { render action: "new" }
        format.json { render json: @white_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /white_cards/1
  # PUT /white_cards/1.json
  def update
    @white_card = WhiteCard.find(params[:id])

    respond_to do |format|
      if @white_card.update_attributes(params[:white_card])
        format.html { redirect_to @white_card, notice: 'White card was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @white_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /white_cards/1
  # DELETE /white_cards/1.json
  def destroy
    @white_card = WhiteCard.find(params[:id])
    @white_card.destroy

    respond_to do |format|
      format.html { redirect_to white_cards_url }
      format.json { head :no_content }
    end
  end
end
