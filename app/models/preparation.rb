class Preparation < ApplicationRecord
    belongs_to :action

    #設定区分完了確認
    def set_sys_check
        
        @sheet = Sheet.find_by(id: self.sheet_id)
        @preparation = Preparation.find_by(id: self.id)
        
        #関連当番の全レコード呼出
        @preparations = Preparation.where(sheet_id: @sheet.id,msys_code: @preparation.msys_code)
        #必須項目の全レコード呼出
        #表示キー項目がセットされていない、必須作業のみ抽出
        @preparations_must = Preparation.where(sheet_id: @sheet.id,msys_code: @preparation.msys_code,must_flg: "1",branch_code: "" || nil)
        @check_flg = "1"
        #全て完了していることの確認
        @preparations_must.each do |preparation|
            if preparation.set_time == nil
                @check_flg = "0"
                break
            end
        end
        #関連当番が全完了の場合全レコードに当番完了時刻をセットする
        if @check_flg == "1"
            donetime = Time.now
            @preparations.each do |preparation|
                preparation.sys_done = donetime
                preparation.save
            end
            #全完了チェック
            @preparations_all = Preparation.where(sheet_id: @sheet.id)
            @check_flg = "1"
            @preparations_all.each do |preparation|
                if preparation.sys_done == nil
                    @check_flg = "0"
                    break
                end
            end
            #全当番の完了を以って当番完了とする
            if @check_flg == "1"
                #レコードに完了時刻セット
                @preparations_all.each do |preparation|
                    preparation.pre_done = donetime
                    preparation.save
                end
                #シートに完了時刻セット
                @sheet.predone = donetime
                @sheet.save
                flash[:notice] = "全設定が完了しました"
                redirect_to(sheets_index_path)
                return
            end
        end
    end

    #設定取消
    def set_sys_uncheck
        @sheet = Sheet.find_by(id: self.sheet_id)
        @preparation = Preparation.find_by(id:self.id)
        #シートの設定完了ステータスを変更
        @sheet.predone = nil
        @sheet.save
        #関連当番の全レコード保存
        @preparations = Preparation.where(sheet_id: @sheet.id,msys_code: @preparation.msys_code)
        
        #関連当番が全完了の場合全レコードに当番完了時刻を削除する
        @preparations.each do |preparation|
            preparation.pre_done = nil
            preparation.sys_done = nil
            preparation.save
        end
        
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
