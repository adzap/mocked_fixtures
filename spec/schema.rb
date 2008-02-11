ActiveRecord::Schema.define(:version => 1) do

  create_table "companies", :force => true, :id => false do |t|
    t.string   "name",       :null => false,  :unique => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", :force => true do |t|
    t.integer  "company_id"  :null => false
    t.string   "first_name"  :null => false,  :limit => 25
    t.string   "last_name"   :null => false,  :limit => 25
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  
end