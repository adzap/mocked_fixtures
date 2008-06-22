require 'rubygems'
require 'spec'

$:.unshift File.dirname(__FILE__) + '/../lib'
$:.unshift File.dirname(__FILE__)

require 'active_record'
require 'active_record/fixtures'
require 'active_support'

require 'rspec_on_rails/rspec_on_rails'
require 'flexmock/test_unit'
require 'mocha'

require 'mocked_fixtures/schema_parser'
require 'mocked_fixtures/testcase'
require 'mocked_fixtures/mock_fixtures'
require 'mocked_fixtures/mock_factory'
require 'mocked_fixtures/mocks/rspec'
require 'mocked_fixtures/mocks/flexmock'
require 'mocked_fixtures/mocks/mocha'

require 'resources/company'
require 'resources/employee'


MockedFixtures::SchemaParser.schema_path = File.expand_path(File.dirname(__FILE__) + '/resources/schema.rb')

Test::Unit::TestCase.fixture_path = File.expand_path(File.dirname(__FILE__) + '/resources')

Test::Unit::TestCase.mocked_fixtures_mock_with = :rspec
