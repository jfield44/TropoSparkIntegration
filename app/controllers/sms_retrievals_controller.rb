class SmsRetrievalsController < ApplicationController
  before_action :set_sms_retrieval, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only => [:create, :destroy]
  # GET /sms_retrievals
  # GET /sms_retrievals.json
  def index
    @sms_retrievals = SmsRetrieval.all
  end

  # GET /sms_retrievals/1
  # GET /sms_retrievals/1.json
  def show
  end

  # GET /sms_retrievals/new
  def new
    @sms_retrieval = SmsRetrieval.new
  end

  # GET /sms_retrievals/1/edit
  def edit
  end

  # POST /sms_retrievals
  # POST /sms_retrievals.json
  def create
    @sms_retrieval = SmsRetrieval.new(sms_retrieval_params)

    respond_to do |format|
      if @sms_retrieval.save
        format.html { redirect_to @sms_retrieval, notice: 'Sms retrieval was successfully created.' }
        format.json { render :show, status: :created, location: @sms_retrieval }
      else
        format.html { render :new }
        format.json { render json: @sms_retrieval.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sms_retrievals/1
  # PATCH/PUT /sms_retrievals/1.json
  def update
    respond_to do |format|
      if @sms_retrieval.update(sms_retrieval_params)
        format.html { redirect_to @sms_retrieval, notice: 'Sms retrieval was successfully updated.' }
        format.json { render :show, status: :ok, location: @sms_retrieval }
      else
        format.html { render :edit }
        format.json { render json: @sms_retrieval.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sms_retrievals/1
  # DELETE /sms_retrievals/1.json
  def destroy
    @sms_retrieval.destroy
    respond_to do |format|
      format.html { redirect_to sms_retrievals_url, notice: 'Sms retrieval was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sms_retrieval
      @sms_retrieval = SmsRetrieval.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sms_retrieval_params
      params.require(:sms_retrieval).permit(:phone_number, :room_id)
    end
end
