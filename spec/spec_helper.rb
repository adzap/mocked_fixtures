$: << File.dirname(__FILE__) + '/../lib' << File.dirname(__FILE__)

require 'rubygems'
require 'spec'
gem 'activerecord', '>=2'
require 'active_record'
require 'active_support'

require 'mocked_fixtures/schema_parser'
require 'mocked_fixtures/mock_extensions'
require 'mocked_fixtures/testcase'
require 'mocked_fixtures/mock_fixtures'

begin
  gem 'activerecord-sqlserver-adapter'
  require 'mocked_fixtures/connection_adapters/sqlserver_adapter'
rescue
  puts 'ActiveRecord SQLServer Adapter not present'
end

MockedFixtures::SchemaParser.schema_path = File.expand_path(File.dirname(__FILE__) + '/resources/schema.rb')