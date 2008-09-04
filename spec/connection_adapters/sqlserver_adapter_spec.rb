require File.dirname(__FILE__) + '/../spec_helper'

begin
  gem 'activerecord-sqlserver-adapter'
  require 'active_record/connection_adapters/sqlserver_adapter'
  require 'mocked_fixtures/connection_adapters/sqlserver_adapter'
rescue LoadError, StandardError
  puts 'Testing ActiveRecord SQLServer Adapter skipped'
end

if defined?(ActiveRecord::ConnectionAdapters::SQLServerAdapter)

  ActiveRecord::ConnectionAdapters::SQLServerAdapter.send(:include, MockedFixtures::ConnectionAdapters::SQLServerAdapter)

  describe MockedFixtures::ConnectionAdapters::SQLServerAdapter do
    connect_db('mssql')    
    
    it "should allow SchemDumper to dump primary key option for pk other than 'id'" do
      schema = StringIO.new
      dumper = ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, schema)
      schema.rewind
      schema.read.should match(/create_table "companies", :primary_key => "cid"/)
    end
    
    it "should return primary key and sequence" do
      ActiveRecord::Base.connection.pk_and_sequence_for('companies').should == ['cid', nil]
    end
    
    disconnect_db
  end
end
