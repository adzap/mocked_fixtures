require File.dirname(__FILE__) + '/spec_helper'

describe MockedFixtures::MockFactory do
  before do
    @fixture = {:id => 6, :cid => 6, :name => 'Hot Mocks'}
  end

  [:rspec, :flexmock, :mocha].each do |type|
    require "mocked_fixtures/mocks/#{type}"
    
    describe "with #{type.to_s.titleize} integration" do
      attr_accessor :a_mock
      
      describe "the mocked fixture object created" do
        before do
          @a_mock = MockedFixtures::MockFactory.create_mock(type, Company, @fixture, self)
        end
        
        it "should be identified by model class name and id value" do
          a_mock.inspect.should match(/Company_6/)
        end
        
        it "should have all attributes stubbed" do
          a_mock.should respond_to(:cid, :name, :address, :created_at, :updated_at)
        end

        it "should have attribute values from fixture" do
          a_mock.cid.should == 6
          a_mock.name.should == 'Hot Mocks'
        end

        it "should have id stubbed to fixture id value" do
          a_mock.id.should == 6
        end

        it "should have new_record? stubbed to false" do
          a_mock.new_record?.should be_false
        end
        
        it "should have to_param stubbed to id as string" do
          a_mock.to_param.should == "6"
        end
        
        it "should have errors stubbed" do
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
        
        it "should say it is a kind of model class" do
          a_mock.kind_of?(Company).should be_true
        end
        
        it "should say it is an instance of the model class" do
          a_mock.instance_of?(Company).should be_true
        end
        
        it "should return the model class as its class" do
          a_mock.class.should == Company
        end
      end
      
    end  
  end  

end
