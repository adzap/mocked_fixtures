require File.dirname(__FILE__) + '/spec_helper'

describe "Mocking framework integration" do
    
  describe "extensions for RSpecs Spec::Mock" do
    it "should mock model with all attributes from schema" do
      company = mock_model(Company, :all_attributes => true)
      company.should respond_to(:cid)
      company.should respond_to(:name)
      company.should respond_to(:address)
      company.should respond_to(:created_at)
    end
  end
  
  
end
