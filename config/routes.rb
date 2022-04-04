Rails.application.routes.draw do
  #resources :users
  #resources :sheets
  # resources :infosettings
  #resources :settings
  # resources :choices
  #resources :operations
  # resources :msystems
  # resources :osystems
  # resources :preparations
  # resources :expeople
  # resources :actions
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # resources :operations do
  #   put :sort
  # end
  get 'layouts/loading'=>'layouts#loading'


  #以下より旧版の
  get 'list' => "home#list"

  #User関連
  post "login" => "users#login"
  post 'logout' => "users#logout"
  #get 'systemoperation/login' => "user#login_form"
  get 'login' => "users#login_form"
  get "signup" => "users#new"
  get "users/index" =>"users#index"
  post "users/create"=>"users#create"
  get "users/:emp_code" => "users#show"
  get "users/:emp_code/edit" => "users#edit"
  post "users/:id/destroy" => "users#destroy"
  post "users/:emp_code/update" => "users#update"
  post "users/import" => "usesr#import"
  resources :user do
    collection { post :import }
  end




  #Sheet関連
  #作成
  get 'sheets/new'=>"sheets#new"
  get 'sheets/gexnew'=>"sheets#gexnew"
  get 'sheets/infosetnew'=>"sheets#infosetnew"
  post 'sheets/create' =>"sheets#create"
  post "sheets/:id/person_set"=>"sheets#person_set"
  post "sheets/:id/person_delete"=>"sheets#person_delete"
  get 'sheets/bulk_new' =>"sheets#bulk_new"
  post 'sheets/bulk_create' =>"sheets#bulk_create"
  get 'sheets/bulk_setindex' =>"sheets#bulk_setindex"
  post 'sheets/:id/bulk_set' =>"sheets#bulk_set"
  post 'sheets/:id/div_set' =>"sheets#div_set"
  post 'sheets/csv_exp' =>"sheets#csv_exp"
  post 'sheets/:id/remarks_update' =>"sheets#remarks_update"
  post 'sheets/:id/remarks_do' =>"sheets#remarks_do"
  post 'sheets/:id/remarks_undo' =>"sheets#remarks_undo"

  #参照
  get 'sheets/index' => "sheets#index"
  get 'sheets/setindex' => "sheets#setindex"
  get 'sheets/doneindex' => "sheets#doneindex"
  get 'sheets/:id/edit' => "sheets#edit"
  get 'sheets/:id/setedit' => "sheets#setedit"
  get 'sheets/:id/infoedit' => "sheets#infoedit"
  get 'sheets/:id/infosetedit' => "sheets#infosetedit"
  get 'sheets/:id' => "sheets#show"
  get 'sheets/:id/info' => "sheets#info"
  get 'sheets/:id/gex' => "sheets#gex"
  get 'sheets/:id/gex_set' => "sheets#gex_set"
  post 'sheets/gex_inp/:id/:col1//:col2/:col3' => "sheets#gex_inp"
  post 'sheets/:id/update' => "sheets#update"
  #入力
  post "sheets/do/:id/:act_id" => "sheets#do"
  post "sheets/undo/:id/:act_id" => "sheets#undo"
  post "sheets/set/:id/:prp_id" => "sheets#set"
  post "sheets/unset/:id/:prp_id" => "sheets#unset"
  post 'sheets/:id/set' =>"sheets#set"
  post 'sheets/:id/done' =>"sheets#done"
  post "sheets/:id/destroy" => "sheets#destroy"
  post "sheets/destroy_old_sheets" => "sheets#destroy_old_sheets"
  delete "sheets/:id/destroy" => "sheets#destroy"
  post "sheets/:id/setdestroy" => "sheets#setdestroy"
  post 'sheets/:id/cancel' => "sheets#cancel"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #Operation関連
  get "operations/index" => "operations#index"
  get "operations/infoindex" => "operations#infoindex"
  get "operations/new" => "operations#new"
  get "operations/infonew" => "operations#infonew"
  get "operations/:id" => "operations#edit"
  get "operations/:id/infoedit" => "operations#infoedit"
  post "operations/:id/set_num" => "operations#set_num"
  post "operations/create" => "operations#create"
  post "operations/infocreate" => "operations#infocreate"
  post "operations/:id/update" => "operations#update"
  post "operations/:id/infoupdate" => "operations#infoupdate"
  post "operations/:id/destroy" => "operations#destroy"
  post "operations/:id/infodestroy" => "operations#infodestroy"
  post "operations/:id/valid" => "operations#valid"
  post "operations/import" => "operations#import"
  post "operations/opreset"=>"operations#opreset"
  #ソート用
  
  #post "operations/:id/sort" => "operations#sort"

  #Setting関連
  get "settings/index" => "settings#index"
  get "settings/new/:op_code" => "settings#new"
  get "settings/infonew/:op_code" => "settings#infonew"
  get "settings/edit/:id/:op_code" => "settings#edit"
  get "settings/infoedit/:id/:op_code" => "settings#infoedit"
  post"settings/create" => "settings#create"
  post"settings/infocreate" => "settings#infocreate"
  post"settings/:id/update" => "settings#update"
  post"settings/:id/infoupdate" => "settings#infoupdate"
  post"settings/:id/destroy" => "settings#destroy"
  post"settings/:id/valid" => "settings#valid"
  post"settings/import" => "settings#import"
  

  #Choices関連
  get "choices/index" => "choices#index"
  get "choices/setindex" => "choices#setindex"
  get "choices/new/:op_code" => "choices#new"
  get "choices/setnew/:set_code" => "choices#setnew"
  get "choices/edit/:op_code" => "choices#edit"
  get "choices/setedit/:set_code" => "choices#setedit"
  post "choices/create" => "choices#create"
  post "choices/setcreate" => "choices#setcreate"
  post "choices/:id/update" => "choices#update"
  post "choices/:id/setupdate" => "choices#setupdate"
  post "choices/:id/valid" => "choices#valid"
  post "choices/:id/destroy" => "choices#destroy"
  post "choices/:id/setdestroy" => "choices#setdestroy"
  post "choices/import" => "choices#import"

  #Osystem関連
  get "osystems/index" => "osystems#index"
  get "osystems/new" => "osystems#new"
  get "osystems/:id" => "osystems#edit"
  post "osystems/create" => "osystems#create"
  post "osystems/:id/update" => "osystems#update"
  post "osystems/:id/destroy" => "osystems#destroy"
  post "osystems/:id/validate" => "osystems#validate"
  post "osystems/:id/indvalidate" => "osystems#invalidate"
  post "osystems/import" => "osystems#import"

  #Msystem関連
  get "msystems/index" => "msystems#index"
  get "msystems/new" => "msystems#new"
  get "msystems/:id" => "msystems#edit"
  get "msystems/:id/show" => "msystems#show"
  post "msystems/create" => "msystems#create"
  post "msystems/:id/update" => "msystems#update"
  post "msystems/:id/destroy" => "msystems#destroy"
  post "msystems/:id/validate" => "msystems#validate"
  post "msystems/:id/indvalidate" => "msystems#invalidate"
  post "msystems/import" => "msystems#import"

  #Expepople関連
  get "expeople/:id" => "expeople#edit"
  get "expeople/:id/show" => "expeople#show"
  post "expeople/:id/create" => "expeople#create"
  post "expeople/:id/:exp_id/update" => "expeople#update"
  post "expeople/:id/:exp_id/destroy" => "expeople#destroy"
  post "expeople/:id/do" => "expeople#do"
  post "expeople/:id/undo" => "expeople#undo"
  post "expeople/import" => "expeople#import"

end
