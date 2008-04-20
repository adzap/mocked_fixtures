require File.dirname(__FILE__) + '/spec_helper'

require 'resources/company'
require 'resources/employee'

describe MockedFixtures do
  
  before do
    @fixture_path = File.expand_path(File.dirname(__FILE__) + '/resources')    
    ActiveRecord::Base.connection.disconnect! if ActiveRecord::Base.connection.active?
  end
  
  it "should create fixtures" do
    fixtures = MockFixtures.create_fixtures(@fixture_path, [:companies])
    fixtures.should have(1).instance_of(Fixture)
    fixtures.first['mega_corp'][:name].should == 'Mega Corporation'
  end
  
  it "should return primary key for fixture table" do
    fixtures = MockFixtures.create_fixtures(@fixture_path, [:companies])
    fixtures[0].primary_key_name.should == 'cid'
  end 
  
end