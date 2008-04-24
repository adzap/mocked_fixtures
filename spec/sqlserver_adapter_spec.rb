require File.dirname(__FILE__) + '/spec_helper'

conn = {
  :adapter  => 'sqlserver',
  :host     => 'localhost',
  :mode     => 'odbc', 
  :dsn      => 'activerecord_unittest',
  :database => 'activerecord_unittest',
  :username => 'rails',
  :password => nil
}

ActiveRecord::Base.establish_connection(conn)

ActiveRecord::ConnectionAdapters::SQLServerAdapter.send(:include, MockedFixtures::ConnectionAdapters::SQLServerAdapter)

require 'resources/schema.rb'

describe MockedFixtures::ConnectionAdapters::SQLServerAdapter do
  
  before do
    ActiveRecord::Base.connection.reconnect! unless ActiveRecord::Base.connection.active?
  end
  
  it "should allow SchemDumper to dump primary key option for pk other than 'id'" do
    schema = StringIO.new
    dumper = ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, schema)
    schema.rewind
    schema.read.should match(/create_table "companies", :primary_key => "cid"/)
  end
  
  it "should return primary key and sequence" do
    ActiveRecord::Base.connection.pk_and_sequence_for('companies').should == ['cid', nil]
  end
end