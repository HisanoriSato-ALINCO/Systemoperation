class UsersController < ApplicationController
#非ログイン状態での禁止処理
before_action :authenticate_user, {only: [:index, :show, :edit, :update]}
#ログイン状態での禁止処理
before_action :forbid_login_user, {only: [:login_form, :login]}
#管理者権限が必要な動作のチェック
before_action :ensure_current_user, {only: [:edit, :update]}


    def new
        @user = User.new
    end

    def create
    @user = User.new(
        emp_name: params[:emp_name],
        emp_code: params[:emp_code],
        password: params[:password]
    )
    #確認用パスワードの一致
    if params[:password] != params[:password_c]
        check = "1"
    end

    #重複エラーチェック
    user_c = User.find_by(emp_code: params[:emp_code])
    if user_c
        flash[:notice] = "重複したコードでは登録出来ません"
        render("users/new")
        return
    end

    if check != "1"
        if @user.save
        session[:user_id] = @user.id
        flash[:notice] = "ユーザー登録が完了しました"
        redirect_to(sheets_index_path)
        else
        render("users/new")
        end
    else
        flash[:notice] = "確認用パスワードが一致しません"
        render("users/new")
    end
    #ログイン中の場合、ログインユーザが切り替わらないようにセッションIDをセット
    if @current_user
        session[:user_id] = @current_user.id
    end
    end

    def logout
        session[:user_id] = nil
        flash[:notice] = "ログアウトしました"
        #redirect_to("/login")
        redirect_to(login_path)
    end


    def login
        @user = User.find_by(emp_code: params[:emp_code])
        #ユーザ認証
        if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        flash[:notice] = "ログインしました"
        redirect_to(sheets_index_path)
        else
        @error_message = "社員番号またはパスワードが間違っています"
        @emp_code = params[:emp_code]
        @password = params[:password]
        render("users/login_form")
        
        end
    end

    def login_form
    if @current_user != nil
        redirect_to(sheets_index_path)
    end
    end

    #ここから
    def index
        @users = User.all
    end
    
    def show
        @user = User.find_by(emp_code: params[:emp_code])
    end
    
    def edit
        @user = User.find_by(emp_code: params[:emp_code])
    end
    
    def update
    @user = User.find_by(emp_code: params[:emp_code])
    @user.emp_name = params[:emp_name]
    @user.admin_flg = params[:admin_flg]
    @user.admin_flg = params[:admin_flg]
    
    #パスワード入力がある場合
    if params[:password] != nil || params[:password_c] != nil
        #確認用パスワードの一致
        if params[:password] != params[:password_c]
        check = "1"
        @user.password = params[:password]
        end
        if check != "1"
        if @user.save
            session[:user_id] = @user.id
            flash[:notice] = "ユーザー情報を編集しました"
            redirect_to({controller: :users, action: :show, emp_code: @user.emp_code})
        else
            render("users/edit")
        end
        else
        flash[:notice] = "確認用パスワードが一致しません"
        render("users/edit")
        end
    #パスワード入力が無い場合
    else
        if @user.save
        flash[:notice] = "ユーザー情報を編集しました"
        redirect_to({controller: :users, action: :show, emp_code: @user.emp_code})
        else
        render("users/edit")
        end
    end

    session[:user_id] = @current_user.id
    
    
    end
    
    def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy
    flash[:notice] = "ユーザーを削除しました"
    redirect_to(users_index_path)
    end
    
    def ensure_correct_user
    if @current_user.emp_code != params[:emp_code]
        flash[:notice] = "権限がありません"
        redirect_to(sheets_index_path)
    end
    end

    def import
    User.import(params[:file])
    redirect_to(users_index_path)
    end

    def ensure_current_user
    @user = User.find_by(emp_code: params[:emp_code])
    #ユーザ一致か運用管理者の場合
    if @user.emp_code != @current_user.emp_code 
        if @current_user.admin_flg != "1"
        flash[:notice] = "権限がありません"
        redirect_to(users_index_path)
        end
    end
    end



end


