$: << File.dirname(__FILE__) + '/../lib' << File.dirname(__FILE__)

require 'rubygems'
require 'spec'

require 'active_record'
require 'active_record/fixtures'
require 'active_support'

require 'mocked_fixtures/schema_parser'
require 'mocked_fixtures/testcase'
require 'mocked_fixtures/mock_fixtures'
require 'mocked_fixtures/mock_factory'
require 'mocked_fixtures/mocks/rspec'

require 'rspec_on_rails/rspec_on_rails'

require 'resources/company'
require 'resources/employee'

Spec::Rails::Example::RailsExampleGroup.send(:include, MockedFixtures::Mocks::Rspec)

MockedFixtures::SchemaParser.schema_path = File.expand_path(File.dirname(__FILE__) + '/resources/schema.rb')

Test::Unit::TestCase.fixture_path = File.expand_path(File.dirname(__FILE__) + '/resources')
