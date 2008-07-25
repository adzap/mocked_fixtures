require File.dirname(__FILE__) + '/spec_helper'

describe Test::Unit::TestCase, "extended with mocked_fixtures" do
  
  def klass
    Test::Unit::TestCase
  end
  
  it "should include the mock_fixtures class method" do
    klass.methods.should include('mock_fixtures')
  end  
  
  it "should include aliased setup method for mock fixtures" do
    klass.instance_methods.should include('setup_with_mock_fixtures')
  end
  
  it "should include global_mock_fixtures method" do
    klass.methods.should include('global_mock_fixtures')
  end
 
  it "should define mock fixture accessor methods" do
    klass.setup_mock_fixture_accessors(['companies'])
    klass.instance_methods.should include('mock_companies')
  end
 
  it "should return all fixture table names" do
    klass.all_fixture_table_names.should == ['employees', 'companies']
  end
 
  describe "global mock fixtures" do
    it "should be included for loading" do
      klass.global_mock_fixtures = :companies
      klass.mock_fixtures :employees
      klass.mock_fixture_table_names.should include('companies')
    end
    
    it "should include all fixtures if equals :all" do
      klass.global_mock_fixtures = :all
      klass.mock_fixture_table_names.should == ['employees', 'companies']
    end
  end
  
  describe "mocked fixture accessor" do     
    mock_fixtures :companies, :employees    
    
    before(:all) do
      Test::Unit::TestCase.mock_fixtures_with = :rspec
    end
    
    it "should return single mock fixture object" do
      mock_companies(:mega_corp).name.should == 'Mega Corporation'
    end
    
    it "should return all named fixtures as array" do
      mock_employees(:adam, :jane).size.should == 2
    end
    
    it "should return all fixtures when passed :all option" do
      mock_employees(:all).size.should == 2
    end
    
    #it "should execute block on mock object requested" do
    #  employee = mock_employees(:adam) do |employee|
    #    employee.stub!(:last_name).and_return(employee.last_name.upcase)
    #  end      
    #  employee.last_name.should == "MEEHAN"
    #end
  end
end
