require File.dirname(__FILE__) + '/spec_helper'

describe MockedFixtures::SchemaParser do
  attr_accessor :schema
   
  before do    
    @schema = MockedFixtures::SchemaParser.load_schema
  end

  it "should parser schema file and return hash" do
    schema.should be_a_kind_of(Hash)
  end

  it "should return schema hash with keys for each fixture file" do    
    schema.should have_key("companies")
    schema.should have_key("employees")
  end  
  
  it "should return schema hash with 2 keys" do
    schema.keys.size.should eql(2)
  end
  
  it "should return schema table with columns in array" do    
    schema["companies"][:columns].should == [["cid",        "integer"], 
                                             ["name",       "string"], 
                                             ["created_at", "datetime"], 
                                             ["updated_at", "datetime"]]

    schema["employees"][:columns].should == [["id",         "integer"],
                                             ["company_id", "integer"],
                                             ["first_name", "string"],
                                             ["last_name",  "string"],
                                             ["created_at", "datetime"],
                                             ["updated_at", "datetime"]]
  end
  
  it "should get primary key from table definition options" do
    schema["companies"][:primary_key].should == 'cid' 
  end
end
