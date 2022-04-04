class Sheet < ApplicationRecord
    #テーブルの親子関係を記述
    has_many :actions

    #定数定義
    #レコード(action)の生成判定時に使用(新規シート作成/一括シート区分設定)
        #レコード追加フラグ(通常)
        NRM = "0"
        NRM.freeze
        #レコード追加フラグ(追加)
        ADD = "1"
        ADD.freeze
        #レコード追加フラグ(削除)
        DEL = "2"
        DEL.freeze
        #当番区分
        #請求/締/会計締/月初/運賃/月次/月次翌/販売延長/拡張/臨時
        DIV_NAMES = ["inv","cf","ac","bigm","fare","mnth","mnxt","gex","ex","tmp"]
        DIV_NAMES.freeze

    #明細作成⇒単体シートでの新規作成時と、区分設定一覧画面からの区分設定時に
    #親：操作マスタ⇒作業レコード、子：設定マスタ⇒準備レコードを生成する。
    def create_records
        #@sheet = Sheet.find_by(id: self.sheet.id)
        @sheet= self
        #全てのテーブル呼出
        load_all_table
        #オペレーション情報（マスタを参照して実行管理テーブルと設定テーブルのレコードを作成）
        @operations.each do |operation|
            #モジュール用オペレーションのセット
            @operation = Operation.find_by(id: operation.id)
            #生成判定モジュール呼出
            division_check
            #レコード生成フラグがONの場合のみ関連レコードの生成
            
            if @create_record_flg == ADD
                #関連レコードを取得
                osystem = Osystem.find_by(osys_code: operation.osys_code)
                #実行管理テーブルへのレコード作成
                action = Action.new

                #実行インスタンスにに操作マスタの値を代入
                action.sheet_id = @sheet.id
                #binding.break
                if osystem
                    action.osys_name = osystem.osys_name
                end
                action.op_code = operation.op_code
                action.op_name = operation.op_name
                action.op_num = operation.op_num
                action.op_type = operation.op_type
                action.op_div = operation.op_div
                action.must_flg = operation.must_flg
                action.duty_div = operation.duty_div
                action.osys_code = operation.osys_code
                action.command = operation.command
                action.caution = operation.caution
                action.gex_div = operation.gex_div
                action.ex_div = operation.ex_div
                action.branch_code = operation.branch_code
                action.branch_cont = operation.branch_cont
                action.sbranch_code = operation.sbranch_code
                action.sbranch_cont= operation.sbranch_cont
                action.duty_date = @sheet.duty_date

                #アクション保存
                action.save
                    #アクションインスタンスに紐づいた設定項目を取得
                    settings = Setting.where(op_code: action.op_code)

                    #準備テーブルのレコード作成
                    settings.each do |setting|
                        preparation = Preparation.new
                        #関連レコードを取得
                        msystem = Msystem.find_by(msys_code: setting.msys_code)
                        #準備インスタンスに設定マスタの値を代入
                        preparation.sheet_id = @sheet.id
                        preparation.action_id = action.id
                        preparation.op_code = operation.op_code
                        preparation.op_name = operation.op_name
                        preparation.set_code =setting.set_code
                        preparation.set_name = setting.set_name
                        preparation.set_type = setting.set_type
                        preparation.set_div = setting.set_div
                        preparation.msys_code = setting.msys_code
                        if msystem
                            preparation.msys_name = msystem.msys_name
                        end
                        preparation.must_flg = setting.must_flg
                        preparation.date_div = setting.date_div
                        preparation.set_num = setting.set_num
                        preparation.set_type = setting.set_type
                        preparation.command = setting.command
                        preparation.caution = setting.caution
                        preparation.branch_code = setting.sbranch_code
                        preparation.branch_cont = setting.sbranch_cont
                        preparation.branch_code = setting.sbranch_code
                        preparation.branch_cont = setting.sbranch_cont
                        #準備テーブルへ保存
                        preparation.save
                end
            end
        end
        #月次以外で月次作業を削除
        if @sheet.mnth_flg != "1"
            @actions_m = Action.where(sheet_id: @sheet.id,duty_div: "3.月次当番")
            @actions_m.each do |operation|
                preparations_m = Preparation.where(sheet_id: @sheet.id,op_code: operation.op_code)
                preparations_m.destroy_all 
            end
            @actions_m.destroy_all
        end
    end

    

    #オペレーションマスタからアクションを生成時、選択された当番区分ごとに生成判定を行う
    def division_check
        #レコード追加フラグをOFFにする
        @create_record_flg = ""
        #必須追加フラグをOFFにする
        must_record_flg = ""
        #レコード削除フラグをOFFにする
        delete_record_flg = ""
        #必須削除フラグをOFFにする
        must_delete_flg = ""

        #区分毎に生成判定をチェック
        count = 0
        DIV_NAMES.each do |div_name|
            #変数セット
            div_flg = div_name + "_flg"
            div_d = div_name + "_div"

            #生成判定
            #シートに区分フラグが立っていない場合
            if @sheet.send(div_flg) == NRM || @sheet.send(div_flg) == nil || @sheet.send(div_flg) == ""
                #作業フラグが[通常]のレコードは作る
                if @operation.send(div_d) == NRM
                    @create_record_flg =ADD
                #作業フラグが[追加]のレコードは削除フラグを立てる
                elsif  @operation.send(div_d) == ADD
                    delete_record_flg = DEL
                end
            #フラグが立っている場合
            elsif @sheet.send(div_flg) == ADD

                #作業フラグが[追加]のレコードは作る
                if @operation.send(div_d) == ADD
                    @create_record_flg = ADD
                    #必須作成フラグをONにする
                    must_record_flg = ADD
                #作業フラグが[減少]の場合は削除フラグを立てる
                elsif @operation.send(div_d) == DEL
                    delete_record_flg = DEL
                    must_delete_flg = DEL
                end
            end
        end

        #最終判定
        #削除フラグがONの時
        if delete_record_flg == DEL
            #レコード生成フラグをOFFにする
            @create_record_flg = DEL
        end

        #必須作成フラグがONの時
        if must_record_flg == ADD
            #レコード生成フラグをONにする
            @create_record_flg = ADD
        end

        #必須削除フラグがONの時
        if must_delete_flg == DEL && @operation.mnth_div == "1"
            #binding.break
            #レコード生成フラグをOFFにする
            @create_record_flg = DEL
        end

    end

    #事前設定で自動設置する為の日付計算
    def date_arithmetic
        #@duty_date関数を取得し、それぞれ@duty_date_[x]-->[0~6の数値]を返す
        #1.翌営業日を取得
        #カウント用変数

        c = 0
        @duty_date_c = @duty_date
        #翌営業日が平日にるまで処理日＋1
        while c == 0 do
            @duty_date_c= @duty_date_c + 1
            
            #土日の場合は保存しない
            if @duty_date_c.saturday? || @duty_date_c.sunday?
            #平日の場合は祝日判定
            else
            if HolidayJapan.check(@duty_date_c)
                #祝日の場合は保存しない
            else
                #ループを抜ける
                c=c+1
                #祝日でない場合は日付を保存
                @duty_date_1 = @duty_date_c
            end
            end
        end

        #2.翌々営業日を取得
        c=0
        @duty_date_c = @duty_date_1
        #処理日-1
        while c== 0 do
            @duty_date_c = @duty_date_c + 1

            #土日の場合は保存しない
            if @duty_date_c.saturday? || @duty_date_c.sunday?

            #平日の場合は祝日判定
            else

                if HolidayJapan.check(@duty_date_c)
                    #祝日の場合は保存しない
                else
                    c=c+1
                    #祝日でない場合は日付を保存
                    @duty_date_2 = @duty_date_c
                end
            end
        end


        #3.前営業日を取得
        #カウント用変数
        c = 0
        @duty_date_c = @duty_date
        #翌営業日が平日にるまで処理日＋1
        while c == 0 do
            @duty_date_c= @duty_date_c - 1

            #土日の場合は保存しない
            if @duty_date_c.saturday? || @duty_date_c.sunday?
            #平日の場合は祝日判定
            else
            if HolidayJapan.check(@duty_date_c)
                #祝日の場合は保存しない
            else
                #ループを抜ける
                c=c+1
                #祝日でない場合は日付を保存
                @duty_date_3 = @duty_date_c
            end
            end
        end

        #4.当月20日
        @datestr = @duty_date.to_s
        @datestr = @datestr.slice(0..7) + "20"
        @duty_date_4 = @datestr.to_date

        #5.月初を取得
        #翌月月初
        @duty_date_c = @duty_date.next_month
        @duty_date_5 = @duty_date_c.beginning_of_month

        #6.翌営業日(土曜含む)を取得
        #カウント変数代入
        @duty_date_c = @duty_date
        c=0
        #処理日＋1(日曜祝日を除く)
        while c==0 do
            @duty_date_c= @duty_date_c + 1

            #日曜祝日であれば日付をカウントアップ
            if HolidayJapan.check(@duty_date_c) || @duty_date_c.sunday?
            #日曜祝日以外であれば日付を確定し代入
            else
                c=c+1
                #祝日でない場合は日付を保存
                @duty_date_6 = @duty_date_c
            end
        #ループ終了
        end
    end

    #日付を年月日項目として文字列操作
    def date_conversion
        #@dateを受取り、年月日それぞれ@year,@month,@day変数を返す
        #文字列へ変換
        @datestr = @date.to_s

        #年のセット
        @year = @datestr.slice(0..3)
        #月のセット
        @month = @datestr.slice(5..6)
        #日のセット
        @day = @datestr.slice(8..10)
    end

    #準備レコードへの値セット
    def sete_settig_value
        #@preparationを取得し、設定値区分に応じた値をセットする
        #インスタンス変数-@date,@duty_date_[x],@year,@month,@dayを使用する

        #初期日付を取得した場合、所定の値をセットする
        if @date
            #0.初期値無し
            if @preparation.set_div == "0"
                @preparation.set_cont = nil
            #1.処理日付
            elsif @preparation.set_div == "1"
                @preparation.set_cont = @date
            #2.開始日
            elsif @preparation.set_div == "2"
                @preparation.set_cont = @date
            #3.終了日
            elsif @preparation.set_div == "3"
                @preparation.set_cont = @date
            #4.年
            elsif @preparation.set_div == "4"
                @preparation.set_cont = @year
            #5.月
            elsif @preparation.set_div == "5"
                @preparation.set_cont = @month
            #6.日
            elsif @preparation.set_div == "6"
                @preparation.set_cont = @day
            #7.期
            elsif @preparation.set_div == "7"
                @preparation.set_cont = nil
            #設定区分がnilの場合(情報課作業)
            elsif @preparation.set_div == nil 
                #初期値が指定されている場合は初期値をセット
                @setting = Setting.find_by(set_code: @preparation.set_code)
                if @setting.default_value != nil
                    @preparation.set_cont = @setting.default_value
                    #予備項目に情報課情報をセット
                    @preparation.reserve_item1 = "info"
                else
                    @preparation.set_cont = nil
                end
            #その他(エラー防止)
            else 
                @preparation.set_cont = nil
            end
        end
    end


    #日付の自動セット
    def date_set
        #シートに関連する準備レコードを全て呼出
        @preparations = Preparation.where(sheet_id: @sheet.id)
        #0.当番日付を変数にセット
        @duty_date = @sheet.duty_date

        #日付計算関数を呼出し、日付を取得
        date_arithmetic

        #各レコードの区分を読取り、設定値を自動セット
        @preparations.each do |preparation|
            #インスタンス変数化
            @preparation = Preparation.find_by(id: preparation.id)

            #月次の場合、日付は強制20日セット
            if @sheet.mnth_flg != "1"
                #自動セット日付を読取
                #当日
                if preparation.date_div == "0"
                    @date = @duty_date
                #翌営業日
                elsif preparation.date_div == "1"
                    @date = @duty_date_1
                #翌々営業日
                elsif preparation.date_div == "2"
                    @date = @duty_date_2
                #前営業日
                elsif preparation.date_div == "3"
                    @date = @duty_date_3
                #当月20日
                elsif preparation.date_div == "4"
                    @date = @duty_date_4
                #月初
                elsif preparation.date_div == "5"
                    @date = @duty_date_5
                #翌営業日(土曜含む)
                elsif preparation.date_div == "6"
                    @date = @duty_date_6
                #その他
                else
                    @date = nil
                end
            #月次の場合は強制20日で日付セット
            else
                @date = @duty_date_4
            end

            #日付変換関数を呼出し、年月日を取得
            date_conversion

            #準備レコードへの値セット
            sete_settig_value
            #レコードの保存
            @preparation.save
        end

    end

    #シートと関連レコードの削除
    def delete_records
        @sheet = Sheet.find_by(id: self.id)
        @actions = Action.where(sheet_id: @sheet.id)
        @preparations = Preparation.where(sheet_id: @sheet.id)
        @expeople = Experson.where(sheet_id: @sheet.id)

        @sheet.destroy
        @actions.destroy_all
        @preparations.destroy_all
        @expeople.destroy_all
    end


    #全てのテーブルを事前に呼び出して、ロードを短縮する
    def load_all_table
        @sheets = Sheet.all
        @operations = Operation.all
        @settings = Setting.all
        @choices = Choice.all
        @msystems = Msystem.all
        @osystems = Osystem.all
        @infosettings = Infosetting.all
    end

end
