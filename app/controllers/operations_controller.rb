class OperationsController < ApplicationController
  before_action :set_operation, only: %i[ show edit update destroy ]
  #非ログイン状態ではログイン画面に強制遷移する
  before_action :authenticate_user

  # GET /operations or /operations.json
  def index
    
    
    #締日区分選択がある場合
    if params[:div] || @div 
      #binding.break
      @operations = Operation.where.not(params[:div].to_sym  => "0").order(op_num: :asc)
      #当番区分で抽出
      if params[:duty] == nil
        @operations = Operation.where.not(params[:div].to_sym  => "0").order(op_num: :asc)
      elsif params[:duty] != nil 
        @operations = Operation.where(duty_div: params[:duty]).where.not(params[:div].to_sym  => "0").order(op_num: :asc)
      else
        @operations = Operation.where.not(params[:div].to_sym  => "0").order(op_num: :asc)
      end
    #締日区分選択がない場合
    else
      #当番区分で抽出
      if params[:duty] == nil
        @operations = Operation.where.not(duty_div: "4.情報課作業").order(op_num: :asc)
      elsif params[:duty] != nil 
        @operations = Operation.where(duty_div: params[:duty]).where.not(duty_div: "4.情報課作業").order(op_num: :asc)
      else
        @operations = Operation.where.not(duty_div: "4.情報課作業").order(op_num: :asc)
      end
    end

    #検索用変数保存
    @duty_div = params[:duty]
    @div = params[:div]

    @divs = ["inv","cf","ac","bigm","fare","mnth","mnxt","tmp"] 
    @div_names = ["請求","締","会締","月初","運締","月次","月翌","臨時"]
    #最終行取得用
    @operations_all = Operation.where.not(duty_div: "4.情報課作業").order(op_num: :asc)
    @operation_last = @operations_all.last
  end

  def infoindex
    @operations = Operation.where(duty_div: "4.情報課作業").order(op_num: :asc)
    #@sheets = Sheet.where(set_flg: "1",done_flg: nil).order(duty_date: :asc).paginate(page: params[:page], per_page: 10)
  end

  # GET /operations/1 or /operations/1.json
  def show
  end

  #順番セット用
  def set_num
    #変更対象のOPを取得
    @operation = Operation.find_by(id: params[:id])
    #該当OPを除くOP
    @operations = Operation.where.not(duty_div: "4.情報課作業").and(Operation.where.not(id: params[:id])).order(op_num: :asc)
    #最終番号
    @operation_last = @operations.last
    @last_num = @operation_last.op_num
    @last_num = @last_num.to_i
    #移動元番号
    @from_num = @operation.op_num
    @from_num = @from_num.to_i
    #移動先番号
    @to_num = params[:num]
    @to_num = @to_num.to_i

    #開始位置が0の場合は移動先番号を+1
    if @from_num == 0
      @to_num = @to_num +1
    end
    #最終番号の末尾にまずは保存
    @operation.op_num = @last_num + 1

    #該当OPを除く全OPの番号を1~振替
    @count = 1
    @operations.each do |operation|
      operation.op_num = @count
      operation.save
      @count = @count +1
    end

    #該当OPを保存
    @operation.op_num = @to_num
    @operation.save
    #該当OPの移動先以降のOPを取得
    @to_num_query = @to_num -1
    @operations_to = Operation.where("op_num > ?",@to_num_query).where.not(duty_div: "4.情報課作業").and(Operation.where.not(id: @operation.id)).order(op_num: :asc)
    #移動先以降にOPが存在する場合
    if @operations_to[0]
      #移動先OP以降のOPの順を全て繰り上げる
      @count = @to_num
      @operations_to.each do |operation|
        @count = @count + 1
        operation.op_num = @count
        operation.save
      end
    end
    
    flash[:notice] = "#{@operation.op_name}を#{@to_num}へ移動しました"
    redirect_to(operations_index_path)
  end

  # GET /operations/new
  def new
    @operation = Operation.new
    #最終行レコードを取得
    @operation_last = Operation.last(1)
    @choice = Choice.new
    @osystems = Osystem.where(valid_flg: "1").order(osys_name: :asc)
    
  end

  #情報課作業
  def infonew
    @operation = Operation.new
    #最終行レコードを取得
    @operation_last = Operation.last(1)
    @choice = Choice.new
    @osystems = Osystem.where(valid_flg: "1")
  end


  #編集用取得
  def edit
    @operation = Operation.find_by(id: params[:id])
    @settings = Setting.where(op_code: @operation.op_code)
    @choices = Choice.where(op_code: @operation.op_code)
    @choice = Choice.new
    @osystems = Osystem.all.order(osys_name: :asc)
    @osystem = Osystem.find_by(osys_code: @operation.osys_code)
  end

    #情報課作業編集用取得
    def infoedit
      @operation = Operation.find_by(id: params[:id])
      @settings = Setting.where(op_code: @operation.op_code)
      @choices = Choice.where(op_code: @operation.op_code)
      @choice = Choice.new
      @osystems = Osystem.all
      @osystem = Osystem.find_by(osys_code: @operation.osys_code)
    end

  #更新
  def update
    @operation = Operation.find_by(id: params[:id])
    @settings = Setting.where(op_code: @operation.op_code)
    @choices = Choice.where(op_code: @operation.op_code)
    @choice = Choice.new
    @osystems = Osystem.all
    @osystem = Osystem.find_by(osys_code: params[:osystem][:osys_code]) 
    if @osystem == nil
      @osystem = Osystem.new
    end
    

    @operation.op_name = params[:op_name]
    @operation.op_num = @operation.op_num
    @operation.op_type = params[:op_type]
    @operation.duty_div = params[:duty_div]
    #@operation.op_div = params[:op_div]
    @operation.osys_code = @osystem.osys_code
    @operation.must_flg = params[:must_flg]
    @operation.inv_div = params[:inv_div]
    @operation.cf_div = params[:cf_div]
    @operation.ac_div = params[:ac_div]
    @operation.bigm_div = params[:bigm_div]
    @operation.fare_div = params[:fare_div]
    @operation.mnth_div = params[:mnth_div]
    @operation.mnxt_div = params[:mnxt_div]
    @operation.gex_div = params[:gex_div]
    @operation.tmp_div = params[:tmp_div]
    @operation.ex_div = "0"
    @operation.command = params[:command]
    @operation.caution = params[:caution]
    @operation.branch_code = params[:branch_code]
    @operation.branch_cont = params[:branch_cont]
    @operation.sbranch_code = params[:sbranch_code]
    @operation.sbranch_cont = params[:sbranch_cont]

    #選択肢フラグのチェック
    # if @operation.op_type == "7"
    #   @operation.choice_flg = "1"
    # else
    #   @operation.choice_flg = nil
    # end
    
    #必須記述入力項目のエラーチェック
    if params[:op_name] == nil || params[:op_name] == "" 
      check = "1"
    elsif params[:op_code] == nil || params[:op_code] == ""
      check = "1"
    elsif params[:osystem][:osys_code] == nil || params[:osystem][:osys_code] == ""
      check = "1"
    end

    if check != "1"
        if @operation.save
        flash[:notice] = "オペレーション更新が完了しました"
        redirect_to(operations_index_path)
        else
        render("operations/edit")
        end
    else
        flash[:notice] = "未入力の必須項目があります"
        render("operations/edit")
    end
  end

  #更新
  def infoupdate
    @operation = Operation.find_by(id: params[:id])
    @settings = Setting.where(op_code: @operation.op_code)
    @choices = Choice.where(op_code: @operation.op_code)
    @choice = Choice.new
    @osystems = Osystem.all
    #@osystem = Osystem.find_by(osys_code: params[:osystem][:osys_code]) 
    if @osystem == nil
      @osystem = Osystem.new
    end
    

    @operation.op_name = params[:op_name]
    @operation.op_num = ""
    @operation.duty_div = "4.情報課作業"
    @operation.inv_div = params[:inv_div]
    @operation.cf_div = params[:cf_div]
    @operation.ac_div = params[:ac_div]
    @operation.bigm_div = params[:bigm_div]
    @operation.fare_div = params[:fare_div]
    @operation.mnth_div = params[:mnth_div]
    @operation.mnxt_div = params[:mnxt_div]
    @operation.gex_div = params[:gex_div]
    @operation.tmp_div = params[:tmp_div]
    @operation.ex_div = "0"
    
    #必須記述入力項目のエラーチェック
    if params[:op_name] == nil || params[:op_name] == "" 
      check = "1"
    elsif params[:op_code] == nil || params[:op_code] == ""
      check = "1"
    end

    if check != "1"
        if @operation.save
        flash[:notice] = "オペレーション更新が完了しました"
        redirect_to(operations_infoindex_path)
        else
        render("operations/infoedit")
        end
    else
        flash[:notice] = "未入力の必須項目があります"
        render("operations/infoedit")
    end
  end


  def create
    #--------テスト用
    @operations = Operation.where.not(duty_div: "4.情報課作業").order(op_num: :asc)
    @lastop = @operations.last
    @last_num = @lastop.op_num
    @last_num = @last_num.to_i
    @last_num = @last_num + 1
    #---------
    @operation = Operation.new(
        op_name: params[:op_name],
        # op_code: params[:op_code],
        #テスト用
        #op_num: @last_num,
        #本番用
        op_num:  "0",
        op_type: params[:op_type],
        duty_div: params[:duty_div],
        #op_div: params[:op_div],
        osys_code: params[:osys_code],
        must_flg: params[:must_flg],
        inv_div: params[:inv_div],
        cf_div: params[:cf_div],
        ac_div: params[:ac_div],
        bigm_div: params[:bigm_div],
        fare_div: params[:fare_div],
        mnth_div: params[:mnth_div],
        mnxt_div: params[:mnxt_div],
        gex_div: params[:gex_div],
        tmp_div: params[:tmp_div],
        ex_div: "0",
        command: params[:command],
        caution: params[:caution],
        branch_code: params[:branch_code],
        branch_cont: params[:branch_cont],
        sbranch_code: params[:sbranch_code],
        sbranch_cont: params[:sbranch_cont]
        # if @a_user = User.find_by(emp_code: params[:a_code])
    )
    @choice = Choice.new
    @osystems = Osystem.all

    # #重複エラーチェック
    # operation_c = Operation.find_by(op_code: params[:op_code])
    
    # if operation_c
    #   flash[:notice] = "重複したコードでは登録出来ません"
    #   render("operations/new")
    #   return
    # end

    #必須記述入力項目のエラーチェック
    if params[:op_name] == nil || params[:op_name] == "" 
      check = "1"
    # elsif params[:op_code] == nil || params[:op_code] == ""
    #   check = "1"
    elsif params[:osys_code] == nil || params[:osys_code] == ""
      check = "1"
    end

    
    if check != "1"
        if @operation.save
          #オペコードにidを代入して保存
          @operation.op_code = @operation.id
          @operation.save
        flash[:notice] = "オペレーション登録が完了しました"
        #選択肢のチェック(選択肢フラグが立っている場合はそのまま選択肢編集画面へ)
        if @operation.op_type == "7"
#          @operation.choice_flg = "1"
          @operation.save
          #オペコードにidを代入して保存
          @operation.op_code = @operation.id
          @operation.save
          redirect_to(controller: :choices, action: :edit,op_code: @operation.op_code)
        else
          redirect_to(operations_index_path)
        end
        else
        render("operations/new")
        end
    else
        flash[:notice] = "未入力の必須項目があります"
        render("operations/new")
    end
  end

  def infocreate
    @operation = Operation.new(
        op_name: params[:op_name],
        #op_code: params[:op_code],
        #打刻入力のみに固定
        op_type: "0",
        #対象当番区分は"4.情報課作業"に
        duty_div: "4.情報課作業",
        #op_div: params[:op_div],
        #osys_code: params[:osys_code],
        #必須フラグは任意に
        must_flg: "0",
        #生成フラグのセット
        inv_div: params[:inv_div],
        cf_div: params[:cf_div],
        ac_div: params[:ac_div],
        bigm_div: params[:bigm_div],
        fare_div: params[:fare_div],
        mnth_div: params[:mnth_div],
        mnxt_div: params[:mnxt_div],
        gex_div: params[:gex_div],
        tmp_div: params[:tmp_div],
        ex_div: "0",
    )

    #重複エラーチェック
    # operation_c = Operation.find_by(op_code: params[:op_code])

    # if operation_c
    #   flash[:notice] = "重複したコードでは登録出来ません"
    #   render("operations/infonew")
    #   return
    # end

    #必須記述入力項目のエラーチェック
    if params[:op_name] == nil || params[:op_name] == "" 
      check = "1"
    end

    
    if check != "1"
        if @operation.save
          @operation.op_code = @operation.id
          @operation.save
        flash[:notice] = "オペレーション登録が完了しました"
          #選択肢のチェック(選択肢フラグが立っている場合はそのまま選択肢編集画面へ)
          if @operation.op_type == "7"
  #          @operation.choice_flg = "1"
            @operation.save
            @operation.op_code = @operation.id
            @operation.save
            redirect_to(controller: :choices, action: :edit,op_code: @operation.op_code)
          else
            redirect_to(operations_index_path)
          end
          else
          render("operations/infonew")
        end
    else
        flash[:notice] = "未入力の必須項目があります"
        render("operations/infonew")
    end
  end

  # PATCH/PUT /operations/1 or /operations/1.json

  # DELETE /operations/1 or /operations/1.json
  def destroy
    @operation = Operation.find_by(id: params[:id])
    @choices_op = Choice.where(op_code: @operation.op_code)
    @settings = Setting.where(op_code: @operation.op_code)
    @choice = Choice.new
    #関連する設定項目に紐づく選択肢を削除
    @settings.each do |setting|
      @choices_set = Choice.where(set_code: setting.set_code)
      @choices_set.destroy_all
    end

    @settings.destroy_all
    @choices_op.destroy_all

    #オペレーション位置を取得
    @op_num = @operation.op_num
    #以降の位置のオペレーションを取得
    @operations_after = Operation.where("op_num > ?",@op_num).where.not(id: @operation.id)
    #以降のオペレーションが有る場合
    if @operations_after[0] && @operation.op_num != 0
      count = @op_num
      #以降レコードに対して全件連番を繰り上げて振り直し
      @operations_after.each do |operation|
        operation.op_num = count
        operation.save
        count = count + 1
      end
    end

    if @operation.destroy
      flash[:notice] = "オペレーションと関連項目を削除しました"
      redirect_to(operations_index_path)
    else
      render("operations/edit")
    end
    #@msystem = Msystem.find_by(msys_code: @setting.msys_code)
  end
  def infodestroy
    @operation = Operation.find_by(id: params[:id])
    @choices_op = Choice.where(set_code: @operation.op_code)
    @settings = Setting.where(op_code: @operation.op_code)
    @choice = Choice.new
    #関連する設定項目に紐づく選択肢を削除
    @settings.each do |setting|
      @choices_set = Choice.where(set_code: setting.set_code)
      @choices_set.destroy_all
    end
    @settings.destroy_all
    @choices_op.destroy_all
    if @operation.destroy
      flash[:notice] = "オペレーションと関連項目を削除しました"
      redirect_to(operations_infoindex_path)
    else
      render("operations/infoedit")
    end
    #@msystem = Msystem.find_by(msys_code: @setting.msys_code)
  end

  def opreset
    @operations = Operation.all

    @operations.each do |operation|
        @settings = Setting.where(op_code: operation.op_code)
        if @settings[0]
          @settings.each do |setting|
              setting.operation_id = operation.id
              setting.op_code = operation.id
              setting.save
          end
        end
        operation.op_code= operation.id
        operation.save
    end
    flash[:notice] = "kousinnkannryo"
    redirect_to(operation_index_path)
  end

  # this action will be called via ajax
  # def sort
  #   operation = Operation.find(params[:id])
  #   operation.update(operation_params)
  #   render nothing: true
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operation
      @operation = Operation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def operation_params
      params.fetch(:operation, {})
      params.require(:operation).permit(:name, :row_order_position)
    end
end
