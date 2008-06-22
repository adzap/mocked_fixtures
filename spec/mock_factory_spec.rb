require File.dirname(__FILE__) + '/spec_helper'

describe MockedFixtures::MockFactory do
  def klass; MockedFixtures::MockFactory; end

  before do
    @fixture = { :cid => 6, :name => 'Hot Mocks'}
  end
  
  [:rspec, :flexmock, :mocha].each do |type|
    describe "#{type.to_s.titleize} integration" do
      
      it "should create mock fixture object" do  
        mock = klass.create_mock(type, Company, @fixture, self)
        mock.should_not be_nil
      end
      
      it "should create mock object with all attributes" do  
        mock = klass.create_mock(type, Company, @fixture, self)
        mock.should respond_to(:cid, :name, :address, :created_at, :updated_at)
      end
      
      it "should create mock object with attributes value from fixture" do  
        mock = klass.create_mock(type, Company, @fixture, self)
        mock.cid.should == 6
        mock.name.should == 'Hot Mocks'
      end
    end  
  end
  
end
