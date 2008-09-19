require File.dirname(__FILE__) + '/spec_helper'

describe MockedFixtures::MockConnection do

  before do
    @conn = MockedFixtures::MockConnection.new
  end

  it "should return schema columns for table as MockedFixtures::MockConnection::Column instances" do
    @conn.columns(['companies']).should have(5).instances_of(MockedFixtures::MockConnection::Column)
  end

  describe "type_cast_value" do
    it "should return correct value for integer type" do
      cast(:integer, '1').should == 1
    end

    it "should return correct value for string type" do
      cast(:string, '1').should == '1'
    end

    it "should return correct value for date type" do
      cast(:date, '2008-01-01').should == Date.new(2008, 1, 1)
    end

    it "should return correct value for datetime type" do
      cast(:datetime, '2008-01-01').should == Time.mktime(2008, 1, 1)
    end

    def cast(type, value)
      @conn.type_cast_value(type, value)
    end
  end

  it "should type cast fixture" do
    fixture = Fixture.new([['cid', '1'],['name', 'Mega Corp'], ['created_at', '2008-01-02 03:04:05.1']], Company)
    @conn.type_cast_fixture(fixture, 'companies').should === {:cid => 1, :name => 'Mega Corp', :created_at => Time.mktime(2008,1,2,3,4,5,100000)}
  end

  it 'should insert fixture' do
    @conn.instance_variable_set(:@current_fixture_label, :mega_corp)
    fixture = Fixture.new([['cid', '1'],['name', 'Mega Corp'], ['created_at', '2008-01-02 03:04:05.1']], Company)
    cast_fixture = @conn.type_cast_fixture(fixture, 'companies')

    @conn.insert_fixture(fixture, 'companies')
    @conn.loaded_fixtures.should == {'companies' => {:mega_corp => cast_fixture} }
  end

  describe "Column" do
    before do
      @column = MockedFixtures::MockConnection::Column.new('cid', 'integer')
    end

    it "should return column name" do
      @column.name.should == 'cid'
    end

    it "should return column type" do
      @column.type.should == 'integer'
    end
  end

end
