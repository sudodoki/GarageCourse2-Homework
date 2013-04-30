class BarcodesController < ApplicationController
  before_action :set_barcode, only: [:show, :edit, :update, :destroy]
  include ActionController::Live


  def stream
    begin
      response.header["Content-Type"] = "text/event-stream"
      redis = Redis.new
      redis.subscribe('barcodes.create') do |on|
        on.message do |event, data|
          print event.inspect, data.inspect
          response.stream.write("data: lol\n\n")
        end
      end
    rescue IOError
    ensure
      redis.quit
      response.stream.close
    end
  end
  # GET /barcodes
  # GET /barcodes.json
  def index
    @barcodes = Barcode.all
  end

  # GET /barcodes/1
  # GET /barcodes/1.json
  def show
  end

  # GET /barcodes/new
  def new
    @barcode = Barcode.new
  end

  # GET /barcodes/1/edit
  def edit
  end

  # POST /barcodes
  # POST /barcodes.json
  def create
    @barcode = Barcode.new(barcode_params)
    respond_to do |format|
      if @barcode.save
        $redis.publish('barcodes.create', @barcode.to_json)
        format.html { redirect_to @barcode, notice: 'Barcode was successfully created.' }
        format.json { render action: 'show', status: :created, location: @barcode }
      else
        format.html { render action: 'new' }
        format.json { render json: @barcode.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /barcodes/1
  # PATCH/PUT /barcodes/1.json
  def update
    respond_to do |format|
      if @barcode.update(barcode_params)
        format.html { redirect_to @barcode, notice: 'Barcode was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @barcode.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /barcodes/1
  # DELETE /barcodes/1.json
  def destroy
    @barcode.destroy
    respond_to do |format|
      format.html { redirect_to barcodes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_barcode
      @barcode = Barcode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def barcode_params
      result = params.require(:barcode).permit(:code, :user_id)
      result.merge!({user_id: current_user.id}) unless result[:user_id]
      result
    end
end
