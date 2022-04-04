# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_03_23_024435) do

  create_table "actions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "op_code"
    t.string "op_name"
    t.integer "sheet_id"
    t.integer "op_num"
    t.string "op_type"
    t.string "op_div"
    t.string "must_flg"
    t.string "duty_div"
    t.string "osys_code"
    t.string "osys_name"
    t.string "gex_div"
    t.string "branch_code"
    t.string "branch_cont"
    t.string "sbranch_code"
    t.string "sbranch_cont"
    t.datetime "done_time"
    t.string "done_pcode"
    t.string "done_pname"
    t.text "op_cont"
    t.date "duty_date"
    t.datetime "duty_done"
    t.datetime "alldone"
    t.string "reserve_item1"
    t.string "reserve_item2"
    t.string "reserve_item3"
    t.string "reserve_item4"
    t.string "reserve_item5"
    t.string "command"
    t.string "caution"
    t.string "tmp_div"
    t.string "ex_div"
    t.string "inv_div"
    t.string "cf_div"
    t.string "bigm_div"
    t.string "fare_div"
    t.string "mnth_div"
    t.string "mnxt_div"
    t.string "a_c_div"
  end

  create_table "choices", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "choice_code"
    t.string "choice_name"
    t.string "set_code"
    t.string "op_code"
  end

  create_table "expeople", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ac_code"
    t.string "ac_name"
    t.string "sheet_id"
    t.string "ac_dept"
    t.datetime "done_time"
    t.datetime "set_time"
  end

  create_table "infosettings", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "set_code"
    t.string "iact_code"
    t.text "inivalue"
    t.text "content"
  end

  create_table "msystems", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "msys_code"
    t.string "msys_name"
    t.string "valid_flg"
    t.index ["msys_code"], name: "index_msystems_on_msys_code", unique: true
  end

  create_table "operations", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "op_code"
    t.string "op_name"
    t.integer "op_num"
    t.string "op_type"
    t.string "op_div"
    t.string "must_flg"
    t.string "duty_div"
    t.string "osys_code"
    t.string "command"
    t.string "caution"
    t.string "inv_div"
    t.string "cf_div"
    t.string "ac_div"
    t.string "bigm_div"
    t.string "fare_div"
    t.string "mnth_div"
    t.string "mnxt_div"
    t.string "gex_div"
    t.string "reserve_div1"
    t.string "reserve_div2"
    t.string "reserve_div3"
    t.string "branch_code"
    t.string "branch_cont"
    t.string "sbranch_code"
    t.string "sbranch_cont"
    t.string "reserve_item1"
    t.string "reserve_item2"
    t.string "reserve_item3"
    t.string "reserve_item4"
    t.string "reserve_item5"
    t.string "tmp_div"
    t.string "ex_div"
    t.integer "position"
    t.integer "row_order"
    t.index ["op_code"], name: "index_operations_on_op_code", unique: true
  end

  create_table "osystems", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "osys_code"
    t.string "osys_name"
    t.string "valid_flg"
    t.index ["osys_code"], name: "index_osystems_on_osys_code", unique: true
  end

  create_table "preparations", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "set_code"
    t.string "set_name"
    t.integer "sheet_id"
    t.string "op_code"
    t.string "op_name"
    t.string "set_type"
    t.string "set_div"
    t.string "msys_code"
    t.string "msys_name"
    t.string "date_div"
    t.integer "set_num"
    t.string "op_type"
    t.string "command"
    t.string "caution"
    t.string "branch_code"
    t.string "branch_cont"
    t.datetime "set_time"
    t.string "set_pcode"
    t.string "set_pname"
    t.text "set_cont"
    t.datetime "sys_done"
    t.datetime "pre_done"
    t.string "reserve_item1"
    t.string "reserve_item2"
    t.string "reserve_item3"
    t.string "reserve_item4"
    t.string "reserve_item5"
    t.string "must_flg"
    t.string "ac_flg"
    t.string "action_id"
  end

  create_table "settings", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "set_code"
    t.string "set_name"
    t.string "op_code"
    t.integer "set_num"
    t.string "set_type"
    t.string "set_div"
    t.string "must_flg"
    t.string "msys_code"
    t.string "command"
    t.string "caution"
    t.string "date_div"
    t.string "branch_code"
    t.string "branch_cont"
    t.string "reserve_item1"
    t.string "reserve_item2"
    t.string "reserve_item3"
    t.string "reserve_item4"
    t.string "reserve_item5"
    t.string "sbranch_code"
    t.string "sbranch_cont"
    t.string "choice_flg"
    t.text "default_value"
    t.string "operation_id"
    t.index ["set_code"], name: "index_settings_on_set_code", unique: true
  end

  create_table "sheets", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "duty_date"
    t.datetime "divdone"
    t.datetime "predone"
    t.datetime "opdone"
    t.text "remarks"
    t.datetime "remarks_done"
    t.string "tmp_flg"
    t.string "gex_flg"
    t.string "inv_flg"
    t.string "cf_flg"
    t.string "bigm_flg"
    t.string "fare_flg"
    t.string "mnth_flg"
    t.string "mnxt_flg"
    t.string "ex_flg"
    t.string "ac_flg"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password"
    t.string "emp_code"
    t.string "emp_name"
    t.string "admin_flg"
    t.string "password_digest"
    t.index ["emp_code"], name: "index_users_on_emp_code", unique: true
  end

end
