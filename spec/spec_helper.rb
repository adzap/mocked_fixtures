$: << File.dirname(__FILE__) + '/../lib'

RAILS_ROOT = File.dirname(__FILE__) + '/..'

gem 'activerecord'
gem 'activesupport'
require 'active_support'

require 'mocked_fixtures/test_case'
require 'mocked_fixtures/schema_parser'
#require 'mocked_fixtures/mock_extensions'
