class HandsController < ApplicationController
  # GET /hands
  # GET /hands.json
  def index
    @hands = Hand.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hands }
    end
  end

  # GET /hands/1
  # GET /hands/1.json
  def show
    @hand = Hand.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hand }
    end
  end

  # GET /hands/new
  # GET /hands/new.json
  def new
    @hand = Hand.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hand }
    end
  end

  # GET /hands/1/edit
  def edit
    @hand = Hand.find(params[:id])
  end

  # POST /hands
  # POST /hands.json
  def create
    @hand = Hand.new(params[:hand])

    respond_to do |format|
      if @hand.save
        format.html { redirect_to @hand, notice: 'Hand was successfully created.' }
        format.json { render json: @hand, status: :created, location: @hand }
      else
        format.html { render action: "new" }
        format.json { render json: @hand.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hands/1
  # PUT /hands/1.json
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

  # DELETE /hands/1
  # DELETE /hands/1.json
  def destroy
    @hand = Hand.find(params[:id])
    @hand.destroy

    respond_to do |format|
      format.html { redirect_to hands_url }
      format.json { head :no_content }
    end
  end
end
