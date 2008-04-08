require File.dirname(__FILE__) + '/spec_helper'

describe MockedFixtures::SchemaParser do
   
  before do
    @parser = MockedFixtures::SchemaParser
    @parser.stub!(:schema_path).and_return(File.expand_path(File.dirname(__FILE__) + '/schema.rb'))
  end
  
  it "should parser schema file and return hash" do
    parser.load_schema.should be_a_kind_of(Hash)
  end
  
  it "should return schema hash with 2 keys" do
    parser.load_schema.keys.size.should eql(2)
  end
  
  it "should return schema hash with a companies key" do
    parser.load_schema.should have_key("companies")
  end
  
  it "should return schema hash with a employees key" do
    parser.load_schema.should have_key("employees")
  end
  
  it "should return schema table with columns in array" do
    schema = parser.load_schema
    schema["companies"].should == [["name", "string"], ["created_at", "datetime"], ["updated_at", "datetime"]]
    schema["employees"].should == [["id",         "integer"],
                                   ["company_id", "integer"],
                                   ["first_name", "string"],
                                   ["last_name",  "string"],
                                   ["created_at", "datetime"],
                                   ["updated_at", "datetime"]]
  end
  
  def parser
    @parser
  end
end
