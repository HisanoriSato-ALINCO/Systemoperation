class SettingsController < ApplicationController
  #非ログイン状態ではログイン画面に強制遷移する
  before_action :authenticate_user


  # GET /settings or /settings.json
  def index
    @settings = Setting.all
  end

  # GET /settings/1 or /settings/1.json
  def show
  end

  # GET /settings/new
  def new
    @setting = Setting.new
    @operation = Operation.find_by(op_code: params[:op_code])
    @msystems = Msystem.where(valid_flg: "1")
  end

  def infonew
    @setting = Setting.new
    @operation = Operation.find_by(op_code: params[:op_code])
    @msystems = Msystem.where(valid_flg: "1")
  end

  # GET /settings/1/edit
  def edit
    @setting = Setting.find_by(id: params[:id])
    @operation = Operation.find_by(op_code: params[:op_code])
    @choices = Choice.where(set_code: @setting.set_code)
    @choice = Choice.new
    @msystems = Msystem.all
    @msystem = Msystem.find_by(msys_code: @setting.msys_code)
  end

  def infoedit
    @setting = Setting.find_by(id: params[:id])
    @operation = Operation.find_by(op_code: params[:op_code])
    @choices = Choice.where(set_code: @setting.set_code)
    @choice = Choice.new
    @msystems = Msystem.all
    @msystem = Msystem.find_by(msys_code: @setting.msys_code)
  end

  def update
    @setting = Setting.find_by(id: params[:id])
    @operation = Operation.find_by(op_code: params[:op_code])
    @msystems = Msystem.all
    @msystem = Msystem.find_by(msys_code: params[:msystem][:msys_code])

    @setting.set_name = params[:set_name]
    @setting.set_code = @setting.id
    @setting.set_num = params[:set_num]
    @setting.set_type = params[:set_type]
    @setting.op_code = @operation.op_code
    @setting.msys_code = @msystem.msys_code
    @setting.must_flg = params[:must_flg]
    @setting.set_div = params[:set_div]
    @setting.date_div = params[:date_div]
    @setting.command = params[:command]
    @setting.caution = params[:caution]
    # @setting.branch_code = params[:branch_code]
    # @setting.branch_cont = params[:branch_cont]
    @setting.sbranch_code = params[:sbranch_code]
    @setting.sbranch_cont = params[:sbranch_cont]

    #必須記述入力項目のエラーチェック
    if params[:set_name] == nil || params[:set_name] == ""
      check = "1"
    elsif params[:set_num] == nil || params[:set_num] == ""
      check = "1"
    elsif params[:msystem][:msys_code] == nil || params[:msystem][:msys_code] == ""
      check = "1"
    end

    #選択肢フラグのチェック
    # if @setting.set_type == "7"
    #   @setting.choice_flg = "1"
    # else
    #   @setting.choice_flg = nil
    # end

    if check != "1"
        if @setting.save
        flash[:notice] = "設定登録が完了しました"
        redirect_to({controller: :settings, action: :edit, id: @setting.id, op_code: @operation.op_code} )
        else
        render("settings/edit")
        end
    else
        flash[:notice] = "未入力の必須項目があります"
        render("settings/edit")
    end
  end

  def infoupdate
    @setting = Setting.find_by(id: params[:id])
    @operation = Operation.find_by(op_code: params[:op_code])
    @msystems = Msystem.all
    #@msystem = Msystem.find_by(msys_code: params[:msystem][:msys_code])

    @setting.default_value =  params[:default_value]

    #必須記述入力項目のエラーチェック
    if params[:set_name] == nil || params[:set_name] == ""
      check = "1"
    end

    if check != "1"
        if @setting.save
        flash[:notice] = "設定登録が完了しました"
        redirect_to({controller: :settings, action: :infoedit, id: @setting.id, op_code: @operation.op_code} )
        else
        render("settings/infoedit")
        end
    else
        flash[:notice] = "未入力の必須項目があります"
        render("settings/ifnoedit")
    end
  end

  # POST /settings or /settings.json
  def create
    @operation = Operation.find_by(op_code: params[:op_code])
    @msystems = Msystem.all
    @setting = Setting.new(
      set_name: params[:set_name],
      #set_code: params[:set_code],
      set_num: params[:set_num],
      set_type: params[:set_type],
      op_code: @operation.op_code,
      operation_id: @operation.id,
      msys_code: params[:msys_code],
      must_flg: params[:must_flg],
      set_div: params[:set_div],
      date_div: params[:date_div],
      command: params[:command],
      caution: params[:caution],
      branch_code: "",
      branch_cont: "",
      sbranch_code: params[:sbranch_code],
      sbranch_cont: params[:sbranch_cont]
  )
  #必須記述入力項目のエラーチェック
  if params[:set_name] == nil || params[:set_name] == ""
    check = "1"
  elsif params[:set_num] == nil || params[:set_num] == ""
    check = "1"
  elsif params[:msys_code] == nil || params[:msys_code] == ""
    check = "1"
  end

  #重複エラーチェック
  # setting_c = Setting.find_by(set_code: params[:set_code])
  # if setting_c
  #   flash[:notice] = "重複したコードでは登録出来ません"
  #   render("settings/new")
  #   return
  # end

  if check != "1"
      #選択肢のチェック(選択肢フラグが立っている場合はそのまま選択肢編集画面へ)
    if @setting.set_type == "7"
      # @setting.choice_flg = "1"
      @setting.save
      @setting.set_code = @setting.id
      @setting.save
      redirect_to(controller: :choices, action: :setedit,set_code: @setting.set_code)
    else
      if @setting.save
      @setting.set_code = @setting.id
      @setting.save
      flash[:notice] = "設定登録が完了しました"
      redirect_to({controller: :operations, action: :edit, id: @operation.id} )
      else
      render("settings/new")
      end
    end
  else
      flash[:notice] = "未入力の必須項目があります"
      render("settings/new")
  end
  end

  def infocreate
    @operation = Operation.find_by(op_code: params[:op_code])
    @msystems = Msystem.all
    @setting = Setting.new(
      set_name: params[:set_name],
      set_type: "6",
      op_code: @operation.op_code,
      must_flg: "",
      default_value: params[:default_value],

  )
  #必須記述入力項目のエラーチェック
  if params[:set_name] == nil || params[:set_name] == ""
    check = "1"
  end

  if check != "1"
      #選択肢のチェック(選択肢フラグが立っている場合はそのまま選択肢編集画面へ)
    if @setting.set_type == "7"
      # @setting.choice_flg = "1"
      @setting.save
      @setting.set_code = @setting.id
      @setting.save
      redirect_to(controller: :choices, action: :setedit,set_code: @setting.set_code)
    else
      if @setting.save
        @setting.set_code = @setting.id
        @setting.save
      flash[:notice] = "設定登録が完了しました"
      redirect_to({controller: :operations, action: :infoedit, id: @operation.id} )
      else
      render("settings/infonew")
      end
    end
  else
      flash[:notice] = "未入力の必須項目があります"
      render("settings/infonew")
  end
  end

  def destroy
    @setting = Setting.find_by(id: params[:id])
    @operation = Operation.find_by(op_code: @setting.op_code)
    @choices = Choice.where(set_code: @setting.set_code)
    @choice = Choice.new
    @choices.destroy_all
    @msystems = Msystem.all
    if @setting.destroy
      redirect_to({controller: :operations, action: :edit, id: @operation.id} )
    else
      render("settings/edit")
    end
    #@msystem = Msystem.find_by(msys_code: @setting.msys_code)
  end
  private

end
