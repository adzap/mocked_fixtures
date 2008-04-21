class Company < ActiveRecord::Base
  set_primary_key 'cid'
  
  has_many :employees  
end