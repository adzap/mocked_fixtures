require File.dirname(__FILE__) + '/spec_helper'

describe 'Test::Unit::TestCase', "when extended with mocked_fixtures" do
  
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
    klass.all_fixture_table_names.should include('employees', 'companies')
  end
 
  describe "global mock fixtures" do
    it "should be included for loading" do
      klass.global_mock_fixtures = :companies
      klass.mock_fixtures :employees
      klass.mock_fixture_table_names.should include('companies')
    end
    
    it "should include all fixtures if equals :all" do
      klass.global_mock_fixtures = :all
      klass.mock_fixture_table_names.should include('employees', 'companies')
    end
  end
  
  describe "mocked fixture accessors" do
    mock_fixtures :companies, :employees    
    
    before(:all) do
      Test::Unit::TestCase.mock_fixtures_with :rspec
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
    
    it "should raise error when fixture cannot be found" do
      lambda { mock_companies(:non_fixture) }.should raise_error(StandardError, /No fixture named 'non_fixture'/)
    end
    
    it "should call block on mock object requested" do
      employee = mock_employees(:adam) do |e|
        e.stub!(:last_name).and_return('MEEHAN')
      end
      employee.last_name.should == "MEEHAN"
    end
    
    it "should call block on all mock objects requested" do
      employees = mock_employees(:adam, :jane) do |e|
        e.stub!(:last_name).and_return('same')
      end
      employees.all? {|e| e.last_name.should == "same" }
    end
  end
  
  describe "regular fixtures" do
    fixtures :companies
    
    connect_db('sqlite')
    disconnect_db
    
    it "should be loaded" do
      companies(:mega_corp).should_not be_nil
    end
  end
end
