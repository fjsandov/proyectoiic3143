# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130626182146) do

  create_table "assistances", :force => true do |t|
    t.datetime "date"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "employee_id"
    t.integer  "shift_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "entry_time"
    t.datetime "exit_time"
  end

  add_index "assistances", ["employee_id"], :name => "index_assistances_on_employee_id"
  add_index "assistances", ["shift_id"], :name => "index_assistances_on_shift_id"

  create_table "cleanup_requests", :force => true do |t|
    t.integer  "room_id"
    t.integer  "priority"
    t.string   "status"
    t.text     "start_comments"
    t.datetime "requested_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer  "requested_by"
    t.integer  "started_by"
    t.integer  "finished_by"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.text     "end_comments"
    t.text     "response_comments"
    t.integer  "deleted_by"
    t.datetime "deleted_at"
    t.string   "request_type"
  end

  add_index "cleanup_requests", ["deleted_by"], :name => "index_cleanup_requests_on_deleted_by"
  add_index "cleanup_requests", ["finished_by"], :name => "index_cleanup_requests_on_finished_by"
  add_index "cleanup_requests", ["priority"], :name => "index_cleanup_requests_on_priority"
  add_index "cleanup_requests", ["requested_at"], :name => "index_cleanup_requests_on_requested_at"
  add_index "cleanup_requests", ["room_id"], :name => "index_cleanup_requests_on_room_id"
  add_index "cleanup_requests", ["started_by"], :name => "index_cleanup_requests_on_started_by"
  add_index "cleanup_requests", ["status"], :name => "index_cleanup_requests_on_status"

  create_table "cleanup_requests_employees", :id => false, :force => true do |t|
    t.integer "cleanup_request_id"
    t.integer "employee_id"
  end

  create_table "employees", :force => true do |t|
    t.string   "name"
    t.string   "last_name1"
    t.string   "last_name2"
    t.string   "gender"
    t.string   "religion"
    t.string   "marital_status"
    t.string   "spouse_name"
    t.string   "spouse_occupation"
    t.string   "education_level"
    t.string   "birth_date"
    t.integer  "children"
    t.integer  "occupation_id"
    t.date     "joined_at"
    t.date     "uniform_date"
    t.date     "equipment_date"
    t.boolean  "training"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "employees", ["occupation_id"], :name => "index_employees_on_occupation_id"

  create_table "employees_shifts", :force => true do |t|
    t.integer  "shift_id"
    t.integer  "employee_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "employees_shifts", ["employee_id"], :name => "index_employees_shifts_on_employee_id"
  add_index "employees_shifts", ["shift_id"], :name => "index_employees_shifts_on_shift_id"

  create_table "employees_terminal_cleanups", :id => false, :force => true do |t|
    t.integer "employee_id"
    t.integer "terminal_cleanup_id"
  end

  create_table "log_records", :force => true do |t|
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "log_records", ["user_id"], :name => "index_log_records_on_user_id"

  create_table "maintenance_records", :force => true do |t|
    t.integer  "room_id"
    t.text     "start_comments"
    t.datetime "finished_at"
    t.integer  "finished_by"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "end_comments"
  end

  add_index "maintenance_records", ["finished_by"], :name => "index_maintenance_records_on_finished_by"
  add_index "maintenance_records", ["room_id"], :name => "index_maintenance_records_on_room_id"

  create_table "occupations", :force => true do |t|
    t.string   "name"
    t.integer  "vacation_days"
    t.integer  "admin_leave_days"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "rooms", :force => true do |t|
    t.string   "name"
    t.string   "status"
    t.integer  "sector_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "building"
  end

  add_index "rooms", ["sector_id"], :name => "index_rooms_on_sector_id"
  add_index "rooms", ["status"], :name => "index_rooms_on_status"

  create_table "sectors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "zone",       :null => false
  end

  create_table "shifts", :force => true do |t|
    t.string   "name"
    t.time     "start_time"
    t.time     "end_time"
    t.datetime "expiration_date"
    t.boolean  "monday"
    t.boolean  "tuesday"
    t.boolean  "wednesday"
    t.boolean  "thursday"
    t.boolean  "friday"
    t.boolean  "saturday"
    t.boolean  "sunday"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "comments"
  end

  create_table "terminal_cleanup_instances", :force => true do |t|
    t.integer  "terminal_cleanup_id"
    t.datetime "instance_date"
    t.integer  "updated_by"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.text     "comments"
    t.datetime "original_date"
  end

  add_index "terminal_cleanup_instances", ["terminal_cleanup_id"], :name => "index_terminal_cleanup_instances_on_terminal_cleanup_id"
  add_index "terminal_cleanup_instances", ["updated_by"], :name => "index_terminal_cleanup_instances_on_finished_by"

  create_table "terminal_cleanups", :force => true do |t|
    t.integer  "room_id"
    t.integer  "interval"
    t.text     "comments"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "sector_id"
  end

  add_index "terminal_cleanups", ["room_id"], :name => "index_terminal_cleanups_on_room_id"
  add_index "terminal_cleanups", ["sector_id"], :name => "index_terminal_cleanups_on_sector_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "active",          :default => true
    t.string   "user_type"
    t.string   "name"
    t.string   "last_name1"
    t.string   "last_name2"
    t.string   "gender"
  end

  create_table "vacations", :force => true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "employee_id"
    t.string   "vacation_type"
  end

  add_index "vacations", ["employee_id"], :name => "index_vacations_on_employee_id"

end
