$: << File.dirname(__FILE__) + '/../lib'  << File.dirname(__FILE__) + '/rspec_on_rails' << File.dirname(__FILE__)

require 'rubygems'
require 'spec'
require 'active_record'
require 'active_support'

require 'mocked_fixtures/schema_parser'
require 'mocked_fixtures/mock_extensions'
require 'mocked_fixtures/testcase'
require 'mocked_fixtures/mock_fixtures'