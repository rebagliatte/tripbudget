class LalasController < ApplicationController
  # GET /lalas
  # GET /lalas.json
  def index
    @lalas = Lala.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lalas }
    end
  end

  # GET /lalas/1
  # GET /lalas/1.json
  def show
    @lala = Lala.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lala }
    end
  end

  # GET /lalas/new
  # GET /lalas/new.json
  def new
    @lala = Lala.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lala }
    end
  end

  # GET /lalas/1/edit
  def edit
    @lala = Lala.find(params[:id])
  end

  # POST /lalas
  # POST /lalas.json
  def create
    @lala = Lala.new(params[:lala])

    respond_to do |format|
      if @lala.save
        format.html { redirect_to @lala, notice: 'Lala was successfully created.' }
        format.json { render json: @lala, status: :created, location: @lala }
      else
        format.html { render action: "new" }
        format.json { render json: @lala.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lalas/1
  # PUT /lalas/1.json
  def update
    @lala = Lala.find(params[:id])

    respond_to do |format|
      if @lala.update_attributes(params[:lala])
        format.html { redirect_to @lala, notice: 'Lala was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lala.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lalas/1
  # DELETE /lalas/1.json
  def destroy
    @lala = Lala.find(params[:id])
    @lala.destroy

    respond_to do |format|
      format.html { redirect_to lalas_url }
      format.json { head :no_content }
    end
  end
end
