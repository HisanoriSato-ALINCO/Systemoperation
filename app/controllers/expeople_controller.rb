class ExpeopleController < ApplicationController
  #before_action :set_experson, only: %i[ show edit update destroy ]
  #非ログイン状態ではログイン画面に強制遷移する
  before_action :authenticate_user

  # GET /expeople or /expeople.json
  def index
    @expeople = Experson.all
  end

  # GET /expeople/1 or /expeople/1.json
  def show
  end

  # GET /expeople/new
  def new
    @experson = Experson.new
  end

  #販売延長の設定画面
  def edit
    @sheet = Sheet.find_by(id: params[:id])
  
  @expeople = Experson.where(sheet_id: params[:id])
  @experson = Experson.new
  end

  #販売延長の実行画面
  def show
  @sheet = Sheet.find_by(id: params[:id])
  @expeople = Experson.where(sheet_id: params[:id])
  @experson = Experson.new
  end

# POST /expeople or /expeople.json
def create
  @sheet = Sheet.find_by(id: params[:id])
  @experson = Experson.new(
    sheet_id: @sheet.id,
    ac_name: params[:ac_name],
    ac_code: params[:ac_code],
    ac_dept: params[:ac_dept]
  )
  #必須記述入力項目のエラーチェック
  if params[:ac_name] == nil || params[:ac_name] == "" 
    check = "1"
  elsif params[:ac_code] == nil || params[:ac_code] == "" 
    check = "1"
  elsif params[:ac_dept] == nil || params[:ac_dept] == "" 
    check = "1"
  end
  #設定時刻の入力
  @experson.set_time = Time.now
  @sheet.gex_flg = "1"
  @sheet.save

  if check != "1"
      if @experson.save
        flash[:notice] = "延長者登録が完了しました"
        redirect_to(controller: :expeople, action: :edit, id: @sheet.id)
      else
        render("expeople/edit")
      end
  else
      flash[:notice] = "未入力の項目があります"
      render("expeople/edit")
  end
end

# PATCH/PUT /expeople/1 or /expeople/1.json
def update
  @sheet = Sheet.find_by(id: params[:id])
  @experson = Experson.find_by(id: params[:exp_id])
    @experson.ac_code = params[:ac_code]
    @experson.ac_name = params[:ac_name]
    @experson.ac_dept = params[:ac_dept]

  #必須記述入力項目のエラーチェック
  if params[:ac_name] == nil || params[:ac_name] == "" 
    check = "1"
  elsif params[:ac_code] == nil || params[:ac_code] == "" 
    check = "1"
  elsif params[:ac_dept] == nil || params[:ac_dept] == "" 
    check = "1"
  end

  if check != "1"
      if @experson.save
        flash[:notice] = "延長者登録が完了しました"
        redirect_to(controller: :expeople, action: :edit, id: @sheet.id)
      else
        render("expeople/edit")
      end
  else
      flash[:notice] = "未入力の項目があります"
      render("expeople/edit")
  end
end

#作業完了
def do
  @sheet = Sheet.find_by(id: params[:id])
  @expeople = Experson.where(sheet_id: @sheet.id)
  time = Time.now

  @expeople.each do |experson|
    experson.done_time = time
    experson.save
  end

  flash[:notice] = "販売延長作業を完了しました"
  redirect_to(controller: :sheets, action: :edit, id: @sheet.id)
end

#作業取消
def undo
  @sheet = Sheet.find_by(id: params[:id])
  @expeople = Experson.where(sheet_id: @sheet.id)
  time = Time.now

  @expeople.each do |experson|
    experson.done_time = nil
    experson.save
  end

  flash[:notice] = "販売延長作業を取消しました"
  redirect_to(controller: :sheets, action: :edit, id: @sheet.id)
end

# DELETE /expeople/1 or /expeople/1.json
def destroy
  @sheet = Sheet.find_by(id: params[:id])
  @experson = Experson.find_by(sheet_id: params[:id],id: params[:exp_id])
  @experson.destroy

  @expeople = Experson.where(sheet_id: @sheet.id)
  #販売延長者がいなくなった時、販売延長フラグはOFFにする
  if @expeople[0] == nil
    @sheet.gex_flg = nil
    @sheet.save
  end
  redirect_to(controller: :expeople, action: :edit, id: params[:id])
end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_experson
    #   @experson = Experson.find(params[:id])
    # end

    # # Only allow a list of trusted parameters through.
    # def experson_params
    #   params.fetch(:experson, {})
    # end
end
