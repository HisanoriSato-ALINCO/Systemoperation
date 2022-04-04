class Action < ApplicationRecord
    has_many :preparations
    belongs_to :sheet

    #作業完了チェック
    def duty_div_check
        @sheet = Sheet.find_by(id: self.sheet_id)
        @action= Action.find_by(id: self.id)
        #関連当番の全レコード呼出
        @actions = Action.where(sheet_id: @sheet.id,duty_div: @action.duty_div)
        #必須項目の全レコード呼出
        #表示キー項目がセットされていない、必須作業のみ抽出
        @actions_must = Action.where(sheet_id: @sheet.id,duty_div: @action.duty_div,must_flg: "1",branch_code: "" ,sbranch_code: "")
        @check_flg = "1"
        #全て完了していることの確認
        @actions_must.each do |action|
            if action.done_time == nil
                @check_flg = "0"
                break
            end
        end

        #関連当番が全完了の場合全レコードに当番完了時刻をセットする
        if @check_flg == "1"
            donetime = Time.now
            @actions.each do |action|
                action.duty_done = donetime
                action.save
            end
            #全完了チェック
            @actions_all = Action.where(sheet_id: @sheet.id)
            @check_flg = "1"
            @actions_all.each do |action|
                if action.duty_done == nil
                    @check_flg = "0"
                    break
                end
            end
            #全当番の完了を以って当番完了とする
            if @check_flg == "1"
                #レコードに完了時刻セット
                @actions_all.each do |action|
                    action.alldone = donetime
                    action.save
                end
                #シートに完了時刻セット
                @sheet.opdone = donetime
                @sheet.save
            end
        end
    end
    #当番作業取消
    def duty_div_uncheck
        @sheet = Sheet.find_by(id: self.sheet_id)
        @action= Action.find_by(id: self.id)
        #関連当番の全レコード保存
        @actions = Action.where(sheet_id: @sheet.id,duty_div: @action.duty_div)

        #関連当番が全完了の場合全レコードに当番完了時刻を削除する
        @actions.each do |action|
            action.duty_done = nil
            action.save
        end
    end

end
