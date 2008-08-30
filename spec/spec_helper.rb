$:.unshift File.dirname(__FILE__) + '/../lib'
$:.unshift File.dirname(__FILE__)

require 'rubygems'
require 'spec'

require 'active_record'
require 'active_record/fixtures'
require 'active_support'

require 'rspec-rails/rspec-rails'

require 'mocked_fixtures/schema_parser'
require 'mocked_fixtures/testcase'
require 'mocked_fixtures/mock_fixtures'
require 'mocked_fixtures/mock_factory'
require 'mocked_fixtures/mock_connection'

require 'resources/company'
require 'resources/employee'


MockedFixtures::SchemaParser.schema_path = File.expand_path(File.dirname(__FILE__) + '/resources/schema.rb')

Test::Unit::TestCase.fixture_path = File.expand_path(File.dirname(__FILE__) + '/resources')


