require File.dirname(__FILE__) + '/spec_helper'

describe MockedFixtures::MockFixtures do
  
  before(:all) do
    # just making sure we don't hit the database at all
    ActiveRecord::Base.connection.disconnect! rescue nil
  end
  
  after(:all) do    
    ActiveRecord::Base.connection.reconnect! rescue nil
  end
  
  before(:each) do
    @fixture_path = Test::Unit::TestCase.fixture_path
  end  

  it "should return primary key for fixture table" do
    fixtures = MockedFixtures::MockFixtures.create_fixtures(@fixture_path, [:companies])
    fixtures[0].primary_key_name.should == 'cid'
  end  
  
  it "should create fixtures" do
    fixtures = MockedFixtures::MockFixtures.create_fixtures(@fixture_path, [:companies])
    fixtures.should have(1).instance_of(Fixture)
    fixtures.first['mega_corp'][:name].should == 'Mega Corporation'
  end

  it "should create fixtures with association values inserted" do
    fixtures = MockedFixtures::MockFixtures.create_fixtures(@fixture_path, [:employees])
    fixtures.first['adam'][:company_id].should == Fixtures.identify('mega_corp')
  end
  
end
