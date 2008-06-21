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
end
