【本プログラムの目的】
複雑な当番作業の実行前設定＆実行の管理を行う。

【業務フロー】
1.期間指定での業務実行管理シートを確認
2.各システム担当者による事前設定値を入力
3.当日、業務処理担当による締処理実施
4.有事の際にシステム管理者により実行記録の確認



プログラム版
Rudy 3.0.2
Rils 6.1.5

使用Gem
#CSVインポート用GEM
gem 'roo'

#祝日判定用
gem 'holiday_japan'

#パスワード暗号化用
gem 'bcrypt'

#ページネーション用
gem  'will_paginate'
gem  'bootstrap-will_paginate'
gem 'kaminari'


#ダイアログ編集用(非使用)
gem 'data-confirm-modal'
#出力結果を表として出力するgem(コンソール用)
gem 'hirb'
#マルチバイト文字の表示を補正するgem(コンソール用)
gem 'hirb-unicode'
#↑のhirbのGemをコンソール起動時にHirb.enableと入力して起動する

#jQueryを使用
gem 'jquery-rails'



