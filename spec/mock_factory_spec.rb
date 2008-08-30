require File.dirname(__FILE__) + '/spec_helper'

describe MockedFixtures::MockFactory do
  before do
    @fixture = {:id => 6, :cid => 6, :name => 'Hot Mocks'}
  end

  [:rspec, :flexmock, :mocha].each do |type|
    require "mocked_fixtures/mocks/#{type}"
    
    describe " with #{type.to_s.titleize} integration" do
      attr_accessor :a_mock
      
      before do
        @a_mock = MockedFixtures::MockFactory.create_mock(type, Company, @fixture, self)
      end
      
      it "should create mock fixture object" do        
        a_mock.should_not be_nil
      end
      
      it "should create mock object with all attributes" do        
        a_mock.should respond_to(:cid, :name, :address, :created_at, :updated_at)
      end
      
      it "should create mock object with attributes value from fixture" do
        a_mock.cid.should == 6
        a_mock.name.should == 'Hot Mocks'
      end
      
      it "should create mock with id stubbed to fixture" do
        a_mock.id.should == 6
      end
      
      it "should create mock with new_record? stubbed to false" do
        a_mock.new_record?.should be_false
      end
      
      it "should create mock with to_param stubbed to id as string" do
        a_mock.to_param.should == "6"
      end
      
      it "should create mock with errors stubbed" do
        a_mock.should respond_to(:errors)
      end
      
      describe "mock object errors stub" do
        it "should return 0 for count" do
          a_mock.errors.count.should == 0
        end
        
        it "should return nil for on(:attribute)" do
          a_mock.errors.on(:name).should be_nil
        end
      end
    end  
  end  

end
