require 'active_record/fixtures'

require 'mocked_fixtures/testcase'
require 'mocked_fixtures/schema_parser'
require 'mocked_fixtures/mock_fixtures'
require 'mocked_fixtures/mock_factory'
require 'mocked_fixtures/mocks/rspec'

MockedFixtures::SchemaParser.schema_path = RAILS_ROOT + '/db/schema.rb'
