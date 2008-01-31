require 'mocked_fixtures/schema_parser'
require 'mocked_fixtures/mock_extensions'

Spec::Rails::Example::RailsExampleGroup.send(:include, MockedFixtures::MockExtensions)