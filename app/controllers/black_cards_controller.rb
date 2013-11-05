class BlackCardsController < ApplicationController
  # GET /black_cards
  # GET /black_cards.json
  def index
    @black_cards = BlackCard.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @black_cards }
    end
  end

  # GET /black_cards/1
  # GET /black_cards/1.json
  def show
    @black_card = BlackCard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @black_card }
    end
  end

  # GET /black_cards/new
  # GET /black_cards/new.json
  def new
    @black_card = BlackCard.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @black_card }
    end
  end

  # GET /black_cards/1/edit
  def edit
    @black_card = BlackCard.find(params[:id])
  end

  # POST /black_cards
  # POST /black_cards.json
  def create
    @black_card = BlackCard.new(params[:black_card])

    respond_to do |format|
      if @black_card.save
        format.html { redirect_to @black_card, notice: 'Black card was successfully created.' }
        format.json { render json: @black_card, status: :created, location: @black_card }
      else
        format.html { render action: "new" }
        format.json { render json: @black_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /black_cards/1
  # PUT /black_cards/1.json
  def update
    @black_card = BlackCard.find(params[:id])

    respond_to do |format|
      if @black_card.update_attributes(params[:black_card])
        format.html { redirect_to @black_card, notice: 'Black card was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @black_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /black_cards/1
  # DELETE /black_cards/1.json
  def destroy
    @black_card = BlackCard.find(params[:id])
    @black_card.destroy

    respond_to do |format|
      format.html { redirect_to black_cards_url }
      format.json { head :no_content }
    end
  end
end
