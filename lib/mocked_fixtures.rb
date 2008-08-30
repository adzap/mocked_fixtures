require 'active_record/fixtures'

require 'mocked_fixtures/testcase'
require 'mocked_fixtures/schema_parser'
require 'mocked_fixtures/mock_fixtures'
require 'mocked_fixtures/mock_factory'
require 'mocked_fixtures/mock_connection'
require 'mocked_fixtures/version'

if defined?(Spec::Example)
  require 'mocked_fixtures/spec/configuration'
  Test::Unit::TestCase.mocked_fixtures_mock_framework = :rspec
end

MockedFixtures::SchemaParser.schema_path = RAILS_ROOT + '/db/schema.rb'
