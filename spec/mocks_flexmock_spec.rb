require File.dirname(__FILE__) + '/spec_helper'

describe "Flexmock extensions" do
  
  it "should mock model with all attributes from schema" do
    company = flexmock(:model, Company, :all_attributes => true)
    company.should respond_to(:cid, :name, :address, :created_at, :updated_at)
  end
  
  it "should mock model with errors object" do
    company = flexmock(:model, Company, :add_errors => true)
    company.should respond_to(:errors)
    company.errors.count.should == 0
    company.errors.should respond_to(:on)
  end
end
