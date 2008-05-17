$: << File.dirname(__FILE__) + '/../lib' << File.dirname(__FILE__)

require 'rubygems'
require 'spec'
gem 'activerecord', '>=2'
require 'active_record'
require 'active_support'

require 'mocked_fixtures/schema_parser'
require 'mocked_fixtures/mocks/spec'
require 'mocked_fixtures/testcase'
require 'mocked_fixtures/mock_fixtures'

require 'rspec_on_rails/example_group_factory'
require 'rspec_on_rails/example_group_methods'
require 'rspec_on_rails/rails_example_group'

require 'resources/company'
require 'resources/employee'

begin
  gem 'activerecord-sqlserver-adapter'
  require 'mocked_fixtures/connection_adapters/sqlserver_adapter'
rescue
  puts 'ActiveRecord SQLServer Adapter not present'
end

Spec::Rails::Example::RailsExampleGroup.send(:include, MockedFixtures::Mocks::Spec)

MockedFixtures::SchemaParser.schema_path = File.expand_path(File.dirname(__FILE__) + '/resources/schema.rb')

Spec::Rails::Example::RailsExampleGroup.fixture_path = File.expand_path(File.dirname(__FILE__) + '/resources')
