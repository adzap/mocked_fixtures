require 'mocked_fixtures/test_case'
require 'mocked_fixtures/schema_parser'
require 'mocked_fixtures/mock_extensions'
require 'mocked_fixtures/mock_fixtures'

# need to require spec/rails as this file needs to be included above spec/rails
# in your spec helper. This is because spec/rails runs test/unit once included.
require 'spec/rails'

Spec::Rails::Example::RailsExampleGroup.send(:include, MockedFixtures::MockExtensions)