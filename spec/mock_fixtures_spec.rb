require File.dirname(__FILE__) + '/spec_helper'

describe MockFixtures do
  
  before(:all) do
    # just making sure we don't hit the database at all
    ActiveRecord::Base.connection.disconnect! rescue nil
  end
  
  before(:each) do
    @fixture_path = File.expand_path(File.dirname(__FILE__) + '/resources')    
  end  
  
  it "should create fixtures" do
    fixtures = MockFixtures.create_fixtures(@fixture_path, [:companies])
    fixtures.should have(1).instance_of(Fixture)
    fixtures.first['mega_corp'][:name].should == 'Mega Corporation'
  end

  it "should create fixtures with association values inserted" do
    fixtures = MockFixtures.create_fixtures(@fixture_path, [:employees])
    fixtures.first['adam'][:company_id].should == Fixtures.identify('mega_corp')
  end

  it "should return primary key for fixture table" do
    fixtures = MockFixtures.create_fixtures(@fixture_path, [:companies])
    fixtures[0].primary_key_name.should == 'cid'
  end  
  
  describe "mocked objects" do
    mock_fixtures :companies, :employees
    
    it "should return values for column methods from fixture" do
      mock_companies(:mega_corp).name.should == 'Mega Corporation'
    end
    
    it "should have attributes not in fixture stubbed to return nil" do
      mock_companies(:mega_corp).should respond_to(:address)
      mock_companies(:mega_corp).address.should be_nil
    end
    
    it "should return all named fixtures as array" do
      mock_employees(:adam, :jane).size.should == 2
    end
    
    it "should return all fixtures when passed :all option" do
      mock_employees(:all).size.should == 2
    end
  end  
end
