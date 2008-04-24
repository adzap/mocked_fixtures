require File.dirname(__FILE__) + '/spec_helper'

describe MockedFixtures do
  
  before :all do
    # just making sure we don't hit the database at all
    ActiveRecord::Base.connection.disconnect! if ActiveRecord::Base.connection.active?
  end
  
  after :all do
    ActiveRecord::Base.connection.reconnect!
  end  
  
  before do
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
  
  describe "Objects" do
    mock_fixtures :companies
    
    it "should return values for column methods" do
      mock_companies(:mega_corp).name.should == 'Mega Corporation'
    end
  end  
end