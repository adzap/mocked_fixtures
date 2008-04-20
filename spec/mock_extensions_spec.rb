require File.dirname(__FILE__) + '/spec_helper'

describe "Mock Extensions for Rspec" do
    
  it "should mock model with all attributes from schema" do
    company = mock_model(Company, :all_attributes => true)
    company.should respond_to(:cid)
    company.should respond_to(:name)
    company.should respond_to(:created_at)
  end
  
end