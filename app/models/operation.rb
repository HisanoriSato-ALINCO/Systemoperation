class Operation < ApplicationRecord
    #順番ソート用
    include RankedModel
    ranks :row_order
    has_many :settings
end
