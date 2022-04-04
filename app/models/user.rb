class User < ApplicationRecord
    #パスワード暗号化用
    has_secure_password
end
