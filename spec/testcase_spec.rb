require File.dirname(__FILE__) + '/spec_helper'

# These rspec_on_rails modules redefine the rspec example groups to inherit 
# from Test::Unit::TestCase so we can still use rspec to test the test/unit 
# extensions. Yay!
require 'rspec_on_rails/example_group_factory'
require 'rspec_on_rails/example_group_methods'
require 'rspec_on_rails/rails_example_group'

describe Test::Unit::TestCase do
  
  describe "additional mock fixtures methods" do
    it "should include the mock_fixtures class method" do
      self.class.methods.should include('mock_fixtures')
    end  
    
    it "should include aliased setup method for mock fixtures" do
      methods.should include('setup_with_mock_fixtures')
    end  
  end
  
  describe "mock fixture accessors setup" do
    it "should define mock_company method" do
      self.class.setup_mock_fixture_accessors(['company'])
      self.methods.should include('mock_company')
    end
  end
  
  describe "mock fixture loading" do
    
  end  
  
end
