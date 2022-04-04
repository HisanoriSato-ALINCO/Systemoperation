class InfosettingsController < ApplicationController
  before_action :set_infosetting, only: %i[ show edit update destroy ]
  #非ログイン状態ではログイン画面に強制遷移する
  before_action :authenticate_user

  # GET /infosettings or /infosettings.json
  def index
    @infosettings = Infosetting.all
  end

  # GET /infosettings/1 or /infosettings/1.json
  def show
  end

  # GET /infosettings/new
  def new
    @infosetting = Infosetting.new
  end

  # GET /infosettings/1/edit
  def edit
  end

  # POST /infosettings or /infosettings.json
  def create
    @infosetting = Infosetting.new(infosetting_params)

    respond_to do |format|
      if @infosetting.save
        format.html { redirect_to infosetting_url(@infosetting), notice: "Infosetting was successfully created." }
        format.json { render :show, status: :created, location: @infosetting }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @infosetting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /infosettings/1 or /infosettings/1.json
  def update
    respond_to do |format|
      if @infosetting.update(infosetting_params)
        format.html { redirect_to infosetting_url(@infosetting), notice: "Infosetting was successfully updated." }
        format.json { render :show, status: :ok, location: @infosetting }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @infosetting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /infosettings/1 or /infosettings/1.json
  def destroy
    @infosetting.destroy

    respond_to do |format|
      format.html { redirect_to infosettings_url, notice: "Infosetting was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_infosetting
      @infosetting = Infosetting.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def infosetting_params
      params.fetch(:infosetting, {})
    end
end
