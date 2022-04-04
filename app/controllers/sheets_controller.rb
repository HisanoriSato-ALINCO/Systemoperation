class SheetsController < ApplicationController
    #非ログイン状態ではログイン画面に強制遷移する
    before_action :authenticate_user
    
    #CSV出力用
    require 'csv'



    #実行対象一覧
    def index
        @sheets = Sheet.where.not(divdone: nil).where(opdone: nil).where.not(predone: nil).order(duty_date: :asc).paginate(page: params[:page], per_page: 10)
        
    end

    #設定対象の一覧
    def setindex
        #未設定かつ区分設定完了
        @sheets = Sheet.where(predone: nil).where.not(divdone: nil).order(duty_date: :asc).paginate(page: params[:page], per_page: 10)
    end

    #完了一覧
    def doneindex
        @sheets = Sheet.where.not(opdone: nil).order(duty_date: :asc).paginate(page: params[:page], per_page: 10)

        respond_to do |format|
        format.html
            format.csv do |csv|
                send_sheets_csv(@sheets)
            end
        end
    end

    #区分未設定一覧
    def bulk_setindex
        @sheets = Sheet.where(divdone: nil).order(duty_date: :asc).paginate(page: params[:page], per_page: 10)
    end



    def new
        @sheet = Sheet.new
    end


    def create
        @sheet = Sheet.new
        #設定日付を代入
        @sheet.duty_date = params[:duty_date]
        #区分設定完了時刻を代入
        @sheet.divdone = Time.now()

        #シートにパラメータ代入メソッド呼出
        sheet_params_input

        #作業日が選択されていなければシート作成画面へ戻る
        if params[:duty_date]== nil || params[:duty_date]== ""
            flash[:notice] = "作業日を入力して下さい"
            render("sheets/new")
            return
        end

        #シートの保存
        @sheet.save
        sheet = @sheet

        #レコード作成メソッドの呼出
        sheet.create_records


        #設定日付の自動セット
        sheet.date_set

        #情報課作業の処置機セット
        #info_default_value

        flash[:notice] = "シートを作成しました"
        redirect_to(sheets_setindex_path)

    end
    #情報課作業の初期値セット
    def info_default_value
        @infoacts = Action.where(sheet_id: @sheet.id,duty_div: "4.情報課作業")
        @infoact = @infoacts[0]
        #情報課作業が有るとき
        if @infoact
            @infoprp = Preparation.find_by(sheet_id: @sheet.id,op_code: @infoact.op_code)
            @infosetting = Setting.find_by(set_code: @infoprp.set_code)
            @infoprp.set_cont = @infosetting.default_value
            @infoprp.save
        end
    end

    def bulk_create
        #require 'holiday_japan'
        #変数に日付パラメータを日付化してセット
        if params[:stt_date] != ""
            @stt_date = Date.parse(params[:stt_date])
        end

        if params[:end_date] != ""
            @end_date = Date.parse(params[:end_date])
        end
        #入力エラーチェック
        if @stt_date ==nil || @end_date ==nil
            flash[:notice] = "開始日と終了日はどちらも入力して下さい"
            render("sheets/bulk_new")
            return
        end

        #終了日エラーチェック
        if @stt_date >= @end_date
            flash[:notice] = "終了日は開始日以降にして下さい"
            render("sheets/bulk_new")
            return
        end

        #指定期間で一括作成
        while @stt_date <= @end_date do
            @sheet =
            Sheet.new(
            #指定された実行日をセット
            duty_date: @stt_date,
            )
            if @stt_date.saturday? || @stt_date.sunday?
            #土日の場合は保存しない
            #平日の場合は祝日判定
            else
            if HolidayJapan.check(@stt_date)
                #祝日の場合は保存しない
            else
                #祝日でない場合は保存
                @sheet.save
            end
            end
            #日付を加算
            @stt_date = @stt_date + 1
            #ループ終了
        end
        flash[:notice] = "休日/祝日を除き報告書を作成しました。"
        redirect_to(sheets_bulk_setindex_path)
    end

    def bulk_set
        #シートをセット
        @sheet = Sheet.find_by(id: params[:id])
            
        #区分設定完了時刻を代入
        @sheet.divdone = Time.now()

        #シートにパラメータ代入メソッド呼出
        sheet_params_input

        #シートの保存
        @sheet.save
        sheet = @sheet

        #レコード作成メソッドの呼出
        sheet.create_records

        #設定日付の自動セット
        sheet.date_set

        flash[:notice] = "#{@sheet.duty_date}区分設定完了"
        redirect_to(sheets_bulk_setindex_path)

    end

    #備考セット
    def remarks_update
        @sheet = Sheet.find_by(id: params[:id])
        @sheet.remarks = params[:remarks]
        @sheet.save
        flash[:notice] = "備考を更新しました"
        redirect_to({controller: :sheets, action: :setedit, id: @sheet.id})
    end

    #備考実行
    def remarks_do
        @sheet = Sheet.find_by(id: params[:id])
        @sheet.remarks_done = Time.now
        @sheet.save
        flash[:notice] = "備考完了"
        redirect_to({controller: :sheets, action: :edit, id: @sheet.id})
    end

    #備考実行取消
    def remarks_undo
        @sheet = Sheet.find_by(id: params[:id])
        @sheet.remarks_done = nil
        @sheet.save
        flash[:notice] = "備考を取消しました"
        redirect_to({controller: :sheets, action: :edit, id: @sheet.id})
    end

    #実行ページ
    def edit
        @sheet = Sheet.find_by(id: params[:id])

        #関連レコードのみ呼出
        @actions = Action.where(sheet_id: params[:id]).where.not(duty_div: "4.情報課作業").order(duty_div: :asc,op_num: :asc)
        @action_before = Action.new
        @expeople = Experson.where(sheet_id: @sheet.id)
    end
    #設定ページ
    def setedit
        @sheet = Sheet.find_by(id: params[:id])

        #関連レコードのみ呼出
        @actions = Action.where(sheet_id: params[:id]).where.not(duty_div: "4.情報課作業").order(op_num: :asc)
        @action_before = Action.new
        @preparations = Preparation.where(sheet_id: params[:id]).where.not(reserve_item1: "info").order(msystem: :asc,set_num: :asc)
        @preparation_before = Preparation.new
    end

    #情報課作業ページ
    def infoedit
        @sheet = Sheet.find_by(id: params[:id])

        #関連レコードのみ呼出
        @actions = Action.where(sheet_id: params[:id],duty_div: "4.情報課作業")
        @action_before = Action.new
        @preparations = Preparation.where(sheet_id: params[:id]).order(msystem: :asc,set_num: :asc)
        @preparation_before = Preparation.new
    end

    #情報課設定ページ
    def infosetedit
        @sheet = Sheet.find_by(id: params[:id])

        #関連レコードのみ呼出
        @actions = Action.where(sheet_id: params[:id],duty_div: "4.情報課作業")
        @action_before = Action.new
        @preparations = Preparation.where(sheet_id: params[:id],reserve_item1: "info").order(msystem: :asc,set_num: :asc)
        @preparation_before = Preparation.new
    end

    #削除アクション
    def destroy
        @sheet = Sheet.find_by(id: params[:id])

        if @sheet == nil
            redirect_to(sheets_index_path)
            return
        end
        #シートと関連レコードを削除
        sheet = @sheet
        sheet.delete_records

        flash[:notice] = "シートを削除しました"
        if params[:page] == nil
            redirect_to(sheets_index_path)
        elsif params[:page] == "bulk_setindex"
            redirect_to(sheets_bulk_setindex_path)
        elsif params[:page] == "setindex"
            redirect_to(sheets_setindex_path)
        end
    end

    def donesheet_prohibit
        if @sheet.opdone != nil
            flash[:notice] = "完了シートは編集できません"
            redirect_to(sheets_index_path)
            return
        elsif @sheet.predone == nil
            flash[:notice] = "プレビューでは入力できません"
            redirect_to({controller: :sheets, action: :edit, id: @sheet.id})
        end
    end
    #実行アクション
    def do
        @sheet = Sheet.find_by(id: params[:id])
        @action = Action.find_by(id: params[:act_id])
        @choices = Choice.where(op_code: @action.op_code)
        @user = User.find_by(emp_code: @current_user.emp_code)


        #完了or事前設定未完シートは編集不可
        if @sheet.opdone != nil || @sheet.predone == nil
        #テスト時は下記をコメントアウトして入力可能に
        donesheet_prohibit
        return
        end

        #既に実行済なら更新せずメッセージ表示
        if @action.done_time != nil
            flash[:notice] = "既に実行されたアクションです"
            redirect_to({controller: :sheets, action: :edit, id: @sheet.id})
            return
        end
        #現在時刻を打刻
        @action.done_time =Time.now
        #実行者をセット
        @action.done_pcode = @user.emp_code
        @action.done_pname = @user.emp_name

        #入力値のセット
        if params[:choice]
            @choice = Choice.find_by(id: params[:choice][:choice_id])
            @action.op_cont = @choice.choice_name
        elsif params[:act_cont]
            @action.op_cont = params[:act_cont]
        end

        #アクション保存
        respond_to do |format|
            if @action.save
            #当番完了チェック
            action = @action
            
            action.duty_div_check
            if Sheet.find_by(id: params[:id]).opdone 
                flash[:notice] = "当番作業が完了しました"
                redirect_to(sheets_index_path)
                return
            end    
            if @check_flg == "1"
                return
            end
            
            format.html { redirect_to({controller: :sheets, action: :edit, id: @sheet.id}) } # 編集ページ遷移
            format.js  {render inline: "location.reload();" }# 元ページを位置を変えずにリロード
            else
            format.html { render("sheets/#{@sheet.id}/edit") } # new.html.erbを表示
            format.js { render :errors } # エラー
            end
        end
    end
    #取消アクション
    def undo
        @sheet = Sheet.find_by(id: params[:id])
        @action = Action.find_by(id: params[:act_id])

        #完了or事前設定未完シートは編集不可
        if @sheet.opdone != nil || @sheet.predone == nil
            donesheet_prohibit
            return
        end

        #既に実行済なら更新せずメッセージ表示
        if @action.done_time == nil
            flash[:notice] = "既に取消されています"
            redirect_to({controller: :sheets, action: :edit, id: @sheet.id})
            return
        end
        #現在時刻と入力値の取消
        @action.done_time =nil
        #@action.op_cont = nil
        

        #アクション保存
        respond_to do |format|
            if @action.save
            #当番完了時刻を削除
            action = @action
            action.duty_div_uncheck
            format.html { redirect_to({controller: :sheets, action: :edit, id: @sheet.id}) } # 編集ページ遷移
            format.js  {render inline: "location.reload();" } # 元ページを位置を変えずにリロード
            else
            format.html { render("sheets/#{@sheet.id}/edit") } # new.html.erbを表示
            format.js { render :errors } # エラー
            end
        end
    end
    #完了取消
    def cancel
        @sheet = Sheet.find_by(id: params[:id])
        
        #完了時刻(完了ステータスと共用)をクリア
        @sheet.opdone = nil
        @sheet.save
        #シート編集ページへリダイレクト
        redirect_to(controller: :sheets, action: :edit, id: @sheet.id)
    end

    #設定アクション
    def set
        @sheet = Sheet.find_by(id: params[:id])
        @preparation = Preparation.find_by(id: params[:prp_id])
        @choices = Choice.where(set_code: @preparation.set_code)
        @user = User.find_by(emp_code: @current_user.emp_code)


        #完了シートは編集不可
        if @sheet.opdone != nil
        donesheet_prohibit
        return
        end

        #既に実行済なら更新せずメッセージ表示
        if @preparation.set_time != nil && @preparation.reserve_item1 == nil
            flash[:notice] = "既に実行されたアクションです"
            redirect_to({controller: :sheets, action: :setedit, id: @sheet.id})
            return
        end

        #現在時刻を打刻
        @preparation.set_time =Time.now
        #実行者をセット
        @preparation.set_pcode = @user.emp_code
        @preparation.set_pname = @user.emp_name

        #入力値のセット
        if params[:choice]
            @choice = Choice.find_by(id: params[:choice][:choice_id])
            @preparation.set_cont = @choice.choice_name
        elsif params[:set_cont]
            @preparation.set_cont = params[:set_cont]
        end

        #入力エラーチェック
        if @preparation.must_flg == "1" && (params[:choice] == "" || params[:set_cont] == "")
            flash[:notice] = "空白での更新は出来ません"
            redirect_to({controller: :sheets, action: :setedit, id: @sheet.id})
            return
        end
        #情報課設定の場合はメッセージ表示してリダイレクト
        if @preparation.reserve_item1 == "info"
            @preparation.save
            #設定完了チェック
            binding.break
            preparation = @preparation
            preparation.set_sys_check
            binding.break
            if @check_flg == "1"
                return
            else 
                flash[:notice] = "情報課設定更新完了"
                redirect_to({controller: :sheets, action: :infosetedit, id: @sheet.id})
                return
            end
            
        end

        #アクション保存
        respond_to do |format|
            if @preparation.save
            #当番完了チェック
            preparation = @preparation
            preparation.set_sys_check
            if @check_flg == "1"
                return
            end
            format.html { redirect_to({controller: :sheets, action: :setedit, id: @sheet.id}) } # 編集ページ遷移
            format.js  {render inline: "location.reload();" }# 元ページを位置を変えずにリロード
            else
            format.html { render("sheets/#{@sheet.id}/setedit") } # new.html.erbを表示
            format.js { render :errors } # エラー
            end
        end
    end

    #設定取消アクション
    def unset
        @sheet = Sheet.find_by(id: params[:id])
        @preparation = Preparation.find_by(id: params[:prp_id])

        #完了シートは編集不可
        if @sheet.opdone != nil
            donesheet_prohibit
            return
        end

        #既に実行済なら更新せずメッセージ表示
        if @preparation.set_time == nil
            flash[:notice] = "既に取消されています"
            redirect_to({controller: :sheets, action: :setedit, id: @sheet.id})
            return
        end
        #現在時刻と入力値の取消
        @preparation.set_time =nil
        #@preparation.set_cont = nil


        #アクション保存
        respond_to do |format|
            if @preparation.save
            #当番完了時刻を削除
            preparation = @preparation
            preparation.set_sys_uncheck
            format.html { redirect_to({controller: :sheets, action: :setedit, id: @sheet.id}) } # 編集ページ遷移
            format.js  {render inline: "location.reload();" } # 元ページを位置を変えずにリロード
            else
            format.html { render("sheets/#{@sheet.id}/setedit") } # new.html.erbを表示
            format.js { render :errors } # エラー
            end
        end
    end

    #シートの当番区分フラグをパラメータとして受取り、セットする
    def sheet_params_input
        if params[:sheet]
            @sheet.inv_flg = params[:sheet][:inv_flg]
            @sheet.cf_flg = params[:sheet][:cf_flg]
            @sheet.ac_flg = params[:sheet][:ac_flg]
            @sheet.bigm_flg = params[:sheet][:bigm_flg]
            @sheet.fare_flg = params[:sheet][:fare_flg]
            @sheet.mnth_flg = params[:sheet][:mnth_flg]
            @sheet.mnxt_flg = params[:sheet][:mnxt_flg]
            #binding.break
            @sheet.gex_flg = params[:sheet][:gex_flg]
            @sheet.tmp_flg = params[:sheet][:tmp_flg]
            @sheet.ex_flg = "0"
        end
    end

    #2年経過レコードの削除
    def destroy_old_sheets
        #基準日を2年後に設定
        @cutoff_date = Date.today >> 24
        #基準日以降のシートを抽出
        @del_sheets=Sheet.where(duty_date: @cutoff_date..)
        #シートとシートに紐つくレコードを全て削除
        if @del_sheets[0]
            @del_sheets.each do |sheet|
                @sheet=sheet
                #シートと関連レコードを削除
                sheet.delete_records
            end
            flash[:notice] = "#{@cutoff_date}以降のシートを削除しました。"
        end
        #完了一覧へリダイレクト
        redirect_to(sheets_doneindex_path)
    end
    
    #CSV出力
    def send_sheets_csv(users)
        #ファイル名を指定
        filename = "systemoperation" + Date.current.strftime("%Y%m%d") + ".csv"
        #抽出対象=完了後シート
        @extracted_sheets = Sheet.left_joins(actions: :preparations).select("actions.op_code AS op_code,sheets.id sheet_id,preparations.set_code AS set_code,sheets.*,actions.*,preparations.set_name AS set_name,preparations.set_time AS set_time,preparations.set_pname AS set_pname,preparations.set_cont AS set_cont,preparations.msys_name AS msys_name").where.not(opdone: nil)
        
        #CSVの出力形式を指定
        csv_data = CSV.generate(row_sep: "\r\n", encoding:Encoding::CP932)  do |csv|
        #CSVのヘッダを指定
        header = %w(シートID 作業コード 設定コード 当番作業日付 区分設定完了 事前設定完了 当番完了 備考 備考完了 請求区分 締区分 会計締区分 月初翌区分 運賃締区分 月次区分 月次翌区分 販売延長区分 当番区分 操作システム 作業名 作業時刻 作業者名 入力内容 管理システム 設定名 設定時刻 設定者 設定内容)
        csv << header
        @extracted_sheets.each do |sheet|
        values = [sheet.sheet_id,sheet.op_code,sheet.set_code,sheet.duty_date,sheet.divdone,
            sheet.predone,sheet.opdone,sheet.remarks,sheet.remarks_done,
            sheet.inv_flg,sheet.cf_flg,sheet.ac_flg,sheet.bigm_flg,sheet.fare_flg,
            sheet.mnth_flg,sheet.mnth_flg,sheet.gex_flg,
            sheet.duty_div,sheet.osys_name,sheet.op_name,sheet.done_time,
            sheet.done_pname,sheet.op_cont,
            sheet.msys_name,sheet.set_name,sheet.set_time,sheet.set_pname,sheet.set_cont]
        #m文字列型は改行削除・時刻は日本時刻にタイムゾーンを訂正
        c = 0
        values.each do |value|
            if value != nil 
                if value.instance_of?(String)
                values[c] = value.gsub(/[\r\n]/,"")
                elsif value.kind_of?(ActiveSupport::TimeWithZone)
                values[c] = value.in_time_zone('Tokyo')
                end
            end
            c=c+1
        end
        csv << values
        end
    end
    send_data(csv_data, filename: filename)
    end


    #改行表示用ヘルパー関数
    def html_safe_newline(str)
        h(str).gsub(/\r|\r\n/, "<br>").html_safe 
    end



end
