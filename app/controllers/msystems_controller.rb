class MsystemsController < ApplicationController
  before_action :set_msystem, only: %i[ show edit update destroy ]
  #非ログイン状態ではログイン画面に強制遷移する
  before_action :authenticate_user

  # GET /msystems or /msystems.json
  def index
    #通常パラメータの場合は、有効な操作システムを表示
    if params[:vaild_flg] == "1"
      @msystems = Msystem.where(valid_flg: "1").order(osys_name: :asc)
      @valid_flg = params[:valid_flg]
    #無効パラメータの場合は、無効な操作システムを表示
    elsif params[:valid_flg] == "0"
      @msystems = Msystem.where(valid_flg: "0").order(osys_name: :asc)
      @valid_flg = params[:valid_flg]
    else
      @msystems = Msystem.where(valid_flg: "1").order(osys_name: :asc)
      @valid_flg = params[:valid_flg]
    end
  end

  # GET /msystems/1 or /msystems/1.json
  # def show
  # end

  # GET /msystems/new
  def new
    @msystem = Msystem.new
  end

  # GET /msystems/1/edit
  def edit
  end

  # POST /msystems or /msystems.json
  def create
    @msystem = Msystem.new(msystem_params)
    #@msystem.msys_code = params[:msys_code]
    @msystem.msys_name = params[:msys_name]
    @msystem.valid_flg = "1"
    #重複エラーチェック
    msystem_c = Msystem.find_by(msys_name: params[:msys_name])
    if msystem_c
        flash[:notice] = "既に存在しています"
        render("msystems/new")
        return
    elsif params[:msys_name]==""
      flash[:notice] = "入力して下さい"
        render("msystems/new")
        return
    end
    if @msystem.save
        @msystem.msys_code = @msystem.id
        @msystem.save
        flash[:notice] = "管理SYS登録が完了しました"
        redirect_to(msystems_index_path)
      else
        render("msystems/new")
      end
  end

  # PATCH/PUT /msystems/1 or /msystems/1.json
  def update
    @msystem = Msystem.find_by(id: params[:id])
    @msystem.msys_code = @msystem.id
    @msystem.msys_name = params[:msys_name]

    if @msystem.save
        flash[:notice] = "管理SYS登録が更新しました"
        redirect_to(controller: :msystems, action: :edit,id: @msystem.id)
      else
        render("msystems/edit")
      end
  end

  #無効化
  def invalidate
    @msystem = Msystem.find_by(id: params[:id])
    @msystem.valid_flg = "0"
    @msystem.save

    flash[:notice] = "操作SYSを無効化しました"
    redirect_to msystems_index_path(valid_flg: "0")
  end

  #有効化
  def validate
    @msystem = Msystem.find_by(id: params[:id])
    @msystem.valid_flg = "1"
    @msystem.save

    flash[:notice] = "操作SYSを無効化しました"
    redirect_to msystems_index_path(valid_flg: "1")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_msystem
      @msystem = Msystem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def msystem_params
      params.fetch(:msystem, {})
    end
end
