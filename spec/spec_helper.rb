$: << File.dirname(__FILE__) + '/../lib' << File.dirname(__FILE__) + '/rspec_on_rails' << File.dirname(__FILE__)

gem 'activerecord'
gem 'activesupport'
require 'active_record'
require 'active_support'

require 'mocked_fixtures/test_case'
require 'mocked_fixtures/schema_parser'
require 'mocked_fixtures/mock_extensions'
require 'mocked_fixtures/mock_fixtures'

require 'rspec_on_rails/testcase'
require 'rspec_on_rails/rails_example_group'

Spec::Rails::Example::RailsExampleGroup.send(:include, MockedFixtures::MockExtensions)