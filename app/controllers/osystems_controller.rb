class OsystemsController < ApplicationController
  before_action :set_osystem, only: %i[ show edit update destroy ]
  #非ログイン状態ではログイン画面に強制遷移する
  before_action :authenticate_user

  # GET /osystems or /osystems.json
  def index
    #通常パラメータの場合は、有効な操作システムを表示
    if params[:vaild_flg] == "1"
      @osystems = Osystem.where(valid_flg: "1").order(osys_name: :asc)
      @valid_flg = params[:valid_flg]
    #無効パラメータの場合は、無効な操作システムを表示
    elsif params[:valid_flg] == "0"
      @osystems = Osystem.where(valid_flg: "0").order(osys_name: :asc)
      @valid_flg = params[:valid_flg]
    else
      @osystems = Osystem.where(valid_flg: "1").order(osys_name: :asc)
      @valid_flg = params[:valid_flg]
    end
  end

  # GET /osystems/1 or /osystems/1.json
  def show
  end

  # GET /osystems/new
  def new
    @osystem = Osystem.new
  end

  # GET /osystems/1/edit
  def edit
  end

  # POST /osystems or /osystems.json
  def create
    @osystem = Osystem.new(osystem_params)
    #@osystem.osys_code = params[:osys_code]
    @osystem.osys_name = params[:osys_name]
    @osystem.valid_flg = "1"

    #重複エラーチェック
    osystem_c = Osystem.find_by(osys_name: params[:osys_name])
    if osystem_c
        flash[:notice] = "既に存在しています"
        render("osystems/new")
        return
    elsif params[:osys_name]==""
      flash[:notice] = "入力して下さい"
        render("osystems/new")
        return
    end

    if @osystem.save
      @osystem.osys_code = @osystem.id
        @osystem.save
    
        flash[:notice] = "操作SYS登録が完了しました"
        redirect_to(osystems_index_path)
      else
        render("osystems/new")
      end
  end

  # PATCH/PUT /osystems/1 or /osystems/1.json
  def update
    @osystem = Osystem.find_by(id: params[:id])
    #@osystem.osys_code = params[:osys_code]
    @osystem.osys_name = params[:osys_name]

    if @osystem.save
        @osystem.osys_code = @osystem.id
        @osystem.save
        flash[:notice] = "操作SYS登録が更新しました"
        redirect_to(controller: :osystems, action: :edit,id: @osystem.id)
      else
        render("osystems/edit")
      end
  end

  #無効化
  def invalidate
    @osystem = Osystem.find_by(id: params[:id])
    @osystem.valid_flg = "0"
    @osystem.save

    flash[:notice] = "操作SYSを無効化しました"
    redirect_to osystems_index_path(valid_flg: "0")
  end

  #有効化
  def validate
    @osystem = Osystem.find_by(id: params[:id])
    @osystem.valid_flg = "1"
    @osystem.save

    flash[:notice] = "操作SYSを無効化しました"
    redirect_to osystems_index_path(valid_flg: "1")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_osystem
      @osystem = Osystem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def osystem_params
      params.fetch(:osystem, {})
    end
end
