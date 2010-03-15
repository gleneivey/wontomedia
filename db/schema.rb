# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100315135952) do

  create_table "connections", :force => true do |t|
    t.integer "subject_id"
    t.integer "predicate_id"
    t.integer "obj_id"
    t.integer "connection_desc_id"
    t.integer "flags",              :default => 0, :null => false
    t.string  "kind_of_obj"
    t.string  "scalar_obj"
  end

  create_table "items", :force => true do |t|
    t.string  "name"
    t.string  "title"
    t.text    "description"
    t.string  "sti_type"
    t.integer "flags",       :default => 0, :null => false
  end

end
