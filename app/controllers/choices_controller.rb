class ChoicesController < ApplicationController
  #before_action :set_choice, only: %i[ show edit update destroy ]
  #非ログイン状態ではログイン画面に強制遷移する
  before_action :authenticate_user

  # GET /choices or /choices.json
  def index
    @choices = Choice.all
  end

  # GET /choices/1 or /choices/1.json
  def show
  end

  # GET /choices/new
  def new
    @choice = Choice.new
  end

  # GET /choices/1/edit
  def edit
    @choices = Choice.where(op_code: params[:op_code])
    @choice = Choice.new
    @operation = Operation.find_by(op_code: params[:op_code])
  end

  def setedit
    @choices = Choice.where(set_code: params[:set_code])
    @choice = Choice.new
    @setting = Setting.find_by(set_code: params[:set_code])
    @operation = Operation.find_by(op_code: @setting.op_code)
  end

  # POST /choices or /choices.json
  def create
    @operation = Operation.find_by(op_code: params[:op_code])
    @choice = Choice.new(
      choice_name: params[:choice_name],
      op_code: params[:op_code]
    )
    #必須記述入力項目のエラーチェック
    if params[:choice_name] == nil || params[:choice_name] == "" 
      check = "1"
    end

    if check != "1"
        if @choice.save
          flash[:notice] = "選択肢登録が完了しました"
          redirect_to(controller: :choices, action: :edit, id: @choice.id, op_code: @operation.op_code)
        else
          render("choices/edit")
        end
    else
        flash[:notice] = "選択肢が未入力です"
        render("choices/edit")
    end
  end

  def setcreate
    @setting = Setting.find_by(set_code: params[:set_code])
    @choice = Choice.new(
      choice_name: params[:choice_name],
      set_code: params[:set_code]
    )
    #必須記述入力項目のエラーチェック
    if params[:choice_name] == nil || params[:choice_name] == "" 
      check = "1"
    end

    if check != "1"
        if @choice.save
          flash[:notice] = "選択肢登録が完了しました"
          redirect_to(controller: :choices, action: :setedit, id: @choice.id, set_code: @setting.set_code)
        else
          render("choices/edit")
        end
    else
        flash[:notice] = "選択肢が未入力です"
        render("choices/edit")
    end
  end

  # PATCH/PUT /choices/1 or /choices/1.json
  def update
    @operation = Operation.find_by(op_code: params[:op_code])
    @choice = Choice.find_by(id: params[:id])
      @choice.choice_name =  params[:choice_name]
      @choice.op_code = params[:op_code]

    #必須記述入力項目のエラーチェック
    if params[:choice_name] == nil || params[:choice_name] == "" 
      check = "1"
    end

    if check != "1"
        if @choice.save
          flash[:notice] = "選択肢登録が完了しました"
          redirect_to(controller: :choices, action: :edit, id: @choice.id, op_code: @operation.op_code)
        else
          render("choices/edit")
        end
    else
        flash[:notice] = "選択肢が未入力です"
        render("choices/edit")
    end
  end

  def setupdate
    @setting = Setting.find_by(set_code: params[:set_code])
    @choice = Choice.find_by(id: params[:id])
      @choice.choice_name =  params[:choice_name]
      @choice.set_code = params[:set_code]

    #必須記述入力項目のエラーチェック
    if params[:choice_name] == nil || params[:choice_name] == "" 
      check = "1"
    end

    if check != "1"
        if @choice.save
          flash[:notice] = "選択肢登録が完了しました"
          redirect_to(controller: :choices, action: :setedit, id: @choice.id, set_code: @setting.set_code)
        else
          render("choices/edit")
        end
    else
        flash[:notice] = "選択肢が未入力です"
        render("choices/edit")
    end
  end

  # DELETE /choices/1 or /choices/1.json
  def destroy
    @choice = Choice.find_by(id: params[:id])
    @choice.destroy
    @operation = Operation.find_by(op_code: params[:op_code])
    redirect_to(controller: :choices, action: :edit, id: @choice.id, op_code: @operation.op_code)
  end

  def setdestroy
    @choice = Choice.find_by(id: params[:id])
    @choice.destroy
    @setting = Setting.find_by(set_code: params[:set_code])
    redirect_to(controller: :choices, action: :setedit, id: @choice.id, set_code: @setting.set_code)
  end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_choice
  #     @choice = Choice.find(params[:id])
  #   end

  #   # Only allow a list of trusted parameters through.
  #   def choice_params
  #     params.fetch(:choice, {})
  #   end
end
