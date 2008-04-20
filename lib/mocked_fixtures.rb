require 'mocked_fixtures/testcase'
require 'mocked_fixtures/schema_parser'
require 'mocked_fixtures/mock_extensions'
require 'mocked_fixtures/mock_fixtures'

require 'spec/rails' rescue nil

if defined?(Spec::Rails::Example::RailsExampleGroup)
  Spec::Rails::Example::RailsExampleGroup.send(:include, MockedFixtures::MockExtensions)
end

MockedFixtures::SchemaParser.schema_path = RAILS_ROOT + '/db/schema.rb'